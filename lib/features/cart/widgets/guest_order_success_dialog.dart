import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/routes_manager/routes.dart';

import '../../../core/widget/custom_elevates_button.dart';

class GuestOrderSuccessDialog extends StatelessWidget {
  final String orderId;

  const GuestOrderSuccessDialog({super.key, required this.orderId});

  static void show(BuildContext context, {required String orderId}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GuestOrderSuccessDialog(orderId: orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      contentPadding: EdgeInsets.all(20.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 64,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'order_placed_successfully'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'order_success_subtitle'.tr(args: [orderId]),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: CustomElevatedButton(
              label: 'back_to_home'.tr(),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.mainRoute,
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}