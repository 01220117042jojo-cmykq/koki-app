import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';

class MapBackButton extends StatelessWidget {
  final bool isCloseIcon;

  const MapBackButton({
    super.key,
    this.isCloseIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12.h,
      left: 16.w,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        child: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            isCloseIcon ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded,
            color: ColorManager.primary,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}