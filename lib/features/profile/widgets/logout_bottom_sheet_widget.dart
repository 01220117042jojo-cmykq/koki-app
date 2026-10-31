import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../core/widget/custom_elevates_button.dart';
import '../../../core/widget/custom_outlined_button.dart';
import '../../cart/cubit/cart_cubit.dart';

class LogoutBottomSheetWidget extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutBottomSheetWidget({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 20.h),

          Image.asset(
            ImageAssets.welcome,
            height: 140.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),

          Text(
            'sign_out_title'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
          SizedBox(height: 8.h),

          Text(
            'sign_out_confirmation'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorManager.darkGrey,
            ),
          ),
          SizedBox(height: 28.h),

          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  label: 'yes'.tr(),
                  isStadiumBorder: true,
                  onTap: () {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    onConfirm();
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomOutlinedButton(
                  text: 'no'.tr(),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}