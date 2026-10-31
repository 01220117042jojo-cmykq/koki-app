import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';

class ProductInfoHeader extends StatelessWidget {
  final String title;
  final double price;
  final double oldPrice;
  final bool onSale;

  const ProductInfoHeader({
    super.key,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.onSale,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.darkSlate,
              height: 1.3,
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${price.toStringAsFixed(2)} EGP",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: ColorManager.primary,
                ),
              ),

              if (onSale) SizedBox(width: 12.w),

              if (onSale)
                Text(
                  "${oldPrice.toStringAsFixed(2)} EGP",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ColorManager.grey,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}