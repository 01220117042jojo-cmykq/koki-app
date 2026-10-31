import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/widget/custom_elevates_button.dart';

class EmptyAddressesWidget extends StatelessWidget {
  final VoidCallback onAddAddressPressed;

  const EmptyAddressesWidget({
    super.key,
    required this.onAddAddressPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageAssets.track, height: 180.h, fit: BoxFit.contain),
          SizedBox(height: 24.h),
          Text(
            "no_address_added".tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "add_address_subtitle".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 180.w,
            child: CustomElevatedButton(
              label: "add_address".tr(),
              onTap: onAddAddressPressed,
            ),
          ),
        ],
      ),
    );
  }
}