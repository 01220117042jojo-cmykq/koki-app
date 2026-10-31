import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.noSearchYet,
            width: 120.w,
            height: 120.h,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.search_off_outlined,
                size: 80.sp,
                color: ColorManager.red,
              );
            },
          ),
          SizedBox(height: 16.h),
          Text(
            "no_searches_yet".tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: ColorManager.black,
            ),
          ),
        ],
      ),
    );
  }
}
