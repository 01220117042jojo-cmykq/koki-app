import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/routes_manager/routes.dart';
import '../../../core/widget/custom_elevates_button.dart';

class OrderSuccessDialog extends StatelessWidget {
  final String orderId;

  const OrderSuccessDialog({
    super.key,
    required this.orderId,
  });

  static void show(BuildContext context, {required String orderId}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrderSuccessDialog(orderId: orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 55.sp,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              "order_placed_successfully".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),

            Text(
              "order_accepted_message".tr(
                namedArgs: {
                  'orderId': orderId.substring(0, orderId.length > 6 ? 6 : orderId.length),
                },
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
               label: "track_my_order".tr(),
                backgroundColor: ColorManager.primary,
                isStadiumBorder: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.myOrders);
                },
              ),
            ),
            SizedBox(height: 8.h),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.mainRoute,
                      (route) => false,
                );
              },
              child: Text(
                "back_to_home".tr(),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}