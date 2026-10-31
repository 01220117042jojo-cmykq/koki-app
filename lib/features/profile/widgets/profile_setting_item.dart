import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/color_manager.dart';

class ProfileSettingItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const ProfileSettingItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22.w,
              height: 22.h,
              colorFilter: ColorFilter.mode(
                ColorManager.darkSlate,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 14.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16  .sp,
                fontWeight: FontWeight.w500,
                color: ColorManager.darkSlate,
              ),
            ),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}