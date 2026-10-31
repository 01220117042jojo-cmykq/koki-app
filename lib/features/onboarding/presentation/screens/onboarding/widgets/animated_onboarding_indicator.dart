import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/resources/color_manager.dart';

class AnimatedOnboardingIndicator extends StatefulWidget {
  final int itemCount;
  final int currentIndex;
  final VoidCallback onPageComplete;

  const AnimatedOnboardingIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.onPageComplete,
  });

  @override
  State<AnimatedOnboardingIndicator> createState() =>
      _AnimatedOnboardingIndicatorState();
}

class _AnimatedOnboardingIndicatorState
    extends State<AnimatedOnboardingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onPageComplete();
      }
    });

    _animationController!.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedOnboardingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController!.reset();
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.itemCount,
        (index) => Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: index < widget.currentIndex
                  ? ColorManager.primary
                  : ColorManager.coolGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: index == widget.currentIndex
                ? AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _animationController!.value,
                        backgroundColor: ColorManager.coolGray.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorManager.primary,
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
