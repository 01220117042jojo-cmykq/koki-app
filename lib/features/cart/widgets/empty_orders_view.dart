import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/assets_manager.dart';
import 'package:koki/core/resources/color_manager.dart';

import '../../../../core/widget/custom_elevates_button.dart';
import '../../main_layout/cubit/main_layout_cubit.dart';

class EmptyOrdersView extends StatelessWidget {
  const EmptyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.chef,
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          Text(
            "no_orders_yet_title".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "no_orders_yet_subtitle".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 220.w,
            child: CustomElevatedButton(
              label: "check_our_offers".tr(),
              backgroundColor: ColorManager.primaryDark,
              isStadiumBorder: true,
              textStyle: TextStyle(
                color: ColorManager.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              onTap: () {
                final mainLayoutCubit = context.read<MainLayoutCubit>();

                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                mainLayoutCubit.changeBottomNav(3);
              },
            ),
          ),
        ],
      ),
    );
  }
}