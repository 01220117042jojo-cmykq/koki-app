import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import '../../../core/widget/custom_elevates_button.dart';
import '../../../core/widget/custom_outlined_button.dart';

class DeleteAddressBottomSheet extends StatelessWidget {
  final VoidCallback onDeletePressed;

  const DeleteAddressBottomSheet({super.key, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "are_you_sure_delete_address".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.black,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  label: "cancel".tr(),
                  backgroundColor: ColorManager.primaryDark,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomOutlinedButton(
                  text: "delete".tr(),
                  onPressed: () {
                    Navigator.pop(context);
                    onDeletePressed();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}