import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String label;
  final Color? backgroundColor;
  final double? radius;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final bool isStadiumBorder;

  const CustomElevatedButton({
    super.key,
    required this.label,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.radius,
    this.textStyle,
    this.isStadiumBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorManager.primary,

        shape: isStadiumBorder
            ? const StadiumBorder()
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 8.r),
        ),

        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            SizedBox(width: 8.w),
          ],

          Text(
            label,
            style: textStyle ?? TextStyle(
              color: ColorManager.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),


          if (suffixIcon != null) ...[
            SizedBox(width: 8.w),
            suffixIcon!,
          ],
        ],
      ),
    );
  }
}