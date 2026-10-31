import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../widget/custom_elevates_button.dart';
import '../cubit/network_cubit.dart';

class OfflineBottomSheet extends StatelessWidget {
  final VoidCallback onContinue;

  const OfflineBottomSheet({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Image.asset(
              ImageAssets.network,
              width: 150.w,
              height: 150.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.h),
            Text(
              'No internet connection.\nPlease try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                label: 'Retry',
                backgroundColor: ColorManager.primaryDark,
                isStadiumBorder: true,
                onTap: () async {
                  final isConnected =
                  await context.read<NetworkCubit>().checkConnection();
                  if (isConnected && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                label: 'Continue',
                backgroundColor: ColorManager.primary,
                isStadiumBorder: true,
                onTap: () {
                  Navigator.pop(context);
                  onContinue();
                },
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}