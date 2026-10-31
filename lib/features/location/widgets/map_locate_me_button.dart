import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';

class MapLocateMeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapLocateMeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16.w,
      bottom: 160.h,
      child: FloatingActionButton(
        heroTag: "btn_locate_me",
        backgroundColor: ColorManager.white,
        elevation: 4,
        onPressed: onPressed,
        child: Icon(Icons.my_location, color: ColorManager.primary),
      ),
    );
  }
}