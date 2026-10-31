import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected ;
  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isSelected = false
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed:onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSelected ? ColorManager.primary : ColorManager.primary,
            width: isSelected ? 2.w : 1.w,

          ),
          padding: EdgeInsets.symmetric(vertical : 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: ColorManager.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500
          )
        )
    );
  }
}
