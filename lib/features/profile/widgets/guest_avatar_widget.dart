import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';

class GuestAvatarWidget extends StatelessWidget {
  const GuestAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 180.w,
      // height: 140.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            ImageAssets.cloud,
            width: 228.w,
            height: 187.h,
            fit: BoxFit.contain,
          ),

          Positioned(
            bottom: 10.h,
            child: Image.asset(
              ImageAssets.welcBanner,
              width: 147.w,
              height: 161.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}