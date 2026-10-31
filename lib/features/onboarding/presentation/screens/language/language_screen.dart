
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/features/onboarding/presentation/screens/language/language_bottom_sheet.dart';
import '../../../../../core/resources/assets_manager.dart';
import '../../../../../core/resources/color_manager.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double whiteSheetHeight = size.height * 0.5;
    final double drividerHeight = 40.h;

    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ImageAssets.backgounrdLang,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 60.h,
              left: 0,
              right: 0,
              bottom: whiteSheetHeight + 10.h,
              child: Center(
                child: SizedBox(
                  width: 315.h,
                  height: 266.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.allIcons,
                        fit: BoxFit.contain,
                      ),
                      Hero(
                        tag: 'logoTag',
                        child: Image.asset(
                          ImageAssets.logo,
                          width: 160.w,
                          height: 135.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: whiteSheetHeight,
              child: Container(
                color: ColorManager.white,
                child: const SafeArea(
                  top: false,
                  child: LanguageBottomSheet(),
                ),
              ),
            ),
            Positioned(
              bottom: whiteSheetHeight - 23.h,
              left: -5.w,
              right: -5.w,
              height: drividerHeight,
              child: SizedBox(
                child: Image.asset(
                  ImageAssets.divider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
