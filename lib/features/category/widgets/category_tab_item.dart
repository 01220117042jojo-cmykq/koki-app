import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';

class CategoryTabItem extends StatelessWidget {
  final String categoryName;
  final String? categoryImage;
  final bool isActive;

  const CategoryTabItem({
    super.key,
    required this.categoryName,
    required this.categoryImage,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105.w,
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: isActive
            ? ColorManager.white.withOpacity(0.2)
            : ColorManager.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isActive ? ColorManager.white : Colors.transparent,
          width: 1.5.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            categoryName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: categoryImage != null && categoryImage!.isNotEmpty
                  ? Image.network(
                categoryImage!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.fastfood, color: Colors.white, size: 20),
              )
                  : const Icon(Icons.fastfood, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}