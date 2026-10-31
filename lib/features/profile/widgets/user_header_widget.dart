import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';

class UserHeaderWidget extends StatelessWidget {
  final String userName;

  const UserHeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130.h,
          color: ColorManager.primary,
          padding: EdgeInsets.only(top: 60.h, bottom: 25.h, left: 16.w, right: 16.w),
          child: Center(
            child: Text(
              "hi_user".tr(args: [userName]),
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Image.asset(
          ImageAssets.frame_home,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }
}