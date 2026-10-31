import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';

class AddressHeaderWidget extends StatelessWidget {
  final String title;

  const AddressHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 90.h + statusBarHeight,
          padding: EdgeInsets.only(top: statusBarHeight + 10.h, left: 16.w, right: 16.w),
          color: ColorManager.primary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: ColorManager.primary, size: 18.sp),
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Image.asset(ImageAssets.frame_home, width: double.infinity, fit: BoxFit.fitWidth),
      ],
    );
  }
}