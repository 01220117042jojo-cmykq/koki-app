import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;

  final int index;

  const OnboardingPageItem({
    super.key,
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: index == 2
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.backGirl,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                      Positioned(
                        width: 260.w,
                        height: 260.h,
                        child: Image.asset(ImageAssets.girl, fit: BoxFit.fill),
                      ),
                    ],
                  )
                : Image.asset(
                    model.image,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
          ),
        ),

        // const SizedBox(height: 24,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
          child: Text(
            model.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 33.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
        ),
        // const SizedBox(height: 12,),
        Padding(
          padding: EdgeInsets.only(
            top: 0.h,
            left: 24.w,
            right: 24.w,
            bottom: 20.h,
          ),
          child: Text(
            model.subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.5.sp,
              color: ColorManager.coolGray,
              height: 1.5,
            ),
          ),
        ),
        // const SizedBox(height: 40,)
      ],
    );
  }
}
