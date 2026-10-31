import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';

import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/widget/top_network_banner.dart';

class CartCheckoutBottomBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckout;

  const CartCheckoutBottomBar({
    super.key,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () async {
            final isConnected =
            await context.read<NetworkCubit>().checkConnection();
            if (!isConnected) {
              if (context.mounted) {
                TopNetworkBanner.show(context);
              }
              return;
            }
            onCheckout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primary,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              "proceed_to_checkout".tr(),
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 1,
                height: 20.h,
                color: ColorManager.white.withOpacity(0.3),
              ),
              SizedBox(width: 12.w),
              Text(
                "${totalPrice.toStringAsFixed(2)} EGP",
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}