import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import '../../../../domain/entities/category_entity.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryEntity category;
  final String? categoryImage;
  final VoidCallback onTap;

  const CategoryItemWidget({
    super.key,
    required this.category,
    this.categoryImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 95.h,
            width: 95.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Center(
              child: categoryImage != null && categoryImage!.trim().isNotEmpty
                  ? Image.network(
                categoryImage!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => CustomLoadingIndicator(size: 35.sp),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CustomLoadingIndicator(size: 35.sp);
                },
              )
                  : CustomLoadingIndicator(size: 35.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}