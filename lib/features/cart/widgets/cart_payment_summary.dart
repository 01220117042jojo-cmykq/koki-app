import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/resources/color_manager.dart';

class CartPaymentSummary extends StatelessWidget {
  final double totalPrice;
  final double vat;
  final double deliveryFee;

  const CartPaymentSummary({
    super.key,
    required this.totalPrice,
    required this.vat,
    required this.deliveryFee,
  });

  @override
  Widget build(BuildContext context) {
    final finalPayment = totalPrice + vat + deliveryFee;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "payment_summary".tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.darkSlate,
            ),
          ),
          SizedBox(height: 12.h),
          buildSummaryRow(
            "total_price".tr(),
            "${totalPrice.toStringAsFixed(2)} ${'egp'.tr()}",
          ),
          SizedBox(height: 8.h),
          buildSummaryRow(
            "vat".tr(),
            "${vat.toStringAsFixed(2)} ${'egp'.tr()}",
          ),
          SizedBox(height: 8.h),
          buildSummaryRow(
            "delivery_fee".tr(),
            "${deliveryFee.toStringAsFixed(2)} ${'egp'.tr()}",
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: ColorManager.grey.withOpacity(0.2)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "total_payment".tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.darkSlate,
                ),
              ),
              Text(
                "${finalPayment.toStringAsFixed(2)} ${'egp'.tr()}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.darkSlate,
          ),
        ),
      ],
    );
  }
}