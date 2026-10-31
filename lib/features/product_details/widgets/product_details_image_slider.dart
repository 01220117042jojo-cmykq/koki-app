import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/color_manager.dart';
import '../../../domain/entities/product_entity.dart';

class ProductDetailsImageSlider extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsImageSlider({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 340.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageAssets.blurBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 340.h,
          alignment: Alignment.bottomCenter,
          child: Image.asset(ImageAssets.test, fit: BoxFit.fitWidth),
        ),
        Container(
          width: double.infinity,
          height: 340.h,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 40.h),
          child: Image.network(
            product.images.isNotEmpty ? product.images[0] : product.thumbnail,
            height: 240.h,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 40.h,
          left: 20.w,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(22.r),
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: ColorManager.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: ColorManager.primary,
                size: 22.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        if (product.onSale)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF39B54A),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
              style: TextStyle(
                color: ColorManager.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
