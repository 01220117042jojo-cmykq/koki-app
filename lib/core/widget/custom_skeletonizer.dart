import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../resources/color_manager.dart';

class CustomSkeletonizer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const CustomSkeletonizer({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: ColorManager.grey.withAlpha(50),
        highlightColor: ColorManager.white,
        duration: const Duration(milliseconds: 1200),
      ),
      child: child,
    );
  }
}