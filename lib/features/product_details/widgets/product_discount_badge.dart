import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';

class ProductDiscountBadge extends StatelessWidget {
  final double discountPercentage;
  final bool onSale;

  const ProductDiscountBadge({
    super.key,
    required this.discountPercentage,
    required this.onSale,
  });

  @override
  Widget build(BuildContext context) {
    if (!onSale) return const SizedBox.shrink();

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFF39B54A),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          '${discountPercentage.toStringAsFixed(0)}% OFF',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}