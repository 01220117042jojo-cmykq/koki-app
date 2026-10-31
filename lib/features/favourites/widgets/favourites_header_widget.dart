import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';

class FavouritesHeaderWidget extends StatelessWidget {
  const FavouritesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130.h,
          color: ColorManager.primary,
          child: Padding(
            padding: EdgeInsets.only(top: 30.h, left: 16.w, right: 16.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: ColorManager.primary,
                      size: 20.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "favorites".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight:  FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),
        ),
        Image.asset(
          ImageAssets.frame_home,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }
}
