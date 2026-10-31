import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../core/routes_manager/routes.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Widget content;

  const ProfileHeaderWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: ColorManager.primary,
          padding: EdgeInsets.only(top: 16.h, bottom: 20.h, left: 20.w, right: 20.w),
          child: Column(
            children: [
              content,
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signInRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                child: Text(
                  "sign_in_or_create_account".tr(),
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
