
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/resources/assets_manager.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/routes_manager/routes.dart';
import '../../../../../core/widget/custom_elevates_button.dart';
import '../../../../../core/widget/custom_outlined_button.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  String? selectedLangCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedLangCode = context.locale.languageCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.h,
        bottom: 24.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Image.asset(ImageAssets.langBadge, width: 50.w, height: 50.h),
            SizedBox(height: 16.h),

            Text(
              'hey_there'.tr(),
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'select_lang'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: ColorManager.darkGrey),
            ),

            SizedBox(height: 32.h),

            Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    text: 'english'.tr(),
                    isSelected: selectedLangCode == 'en',
                    onPressed: () async {
                      setState(() {
                        selectedLangCode = 'en';
                      });
                      await context.setLocale(const Locale('en'));
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomOutlinedButton(
                    text: 'arabic'.tr(),
                    isSelected: selectedLangCode == 'ar',
                    onPressed: () async {
                      setState(() {
                        selectedLangCode = 'ar';
                      });
                      await context.setLocale(const Locale('ar'));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                label: 'continue'.tr(),
                backgroundColor: selectedLangCode != null
                    ? ColorManager.primary
                    : ColorManager.grey,
                isStadiumBorder: true,
                onTap: selectedLangCode != null
                    ? () async {
                  final prefs = GetIt.instance<SharedPreferences>();
                  await prefs.setBool('isLanguageSelected', true);
                  if (mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.onboarding,
                    );
                  }
                }
                    : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}