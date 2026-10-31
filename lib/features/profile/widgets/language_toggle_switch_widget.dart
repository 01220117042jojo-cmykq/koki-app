import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';

class LanguageToggleSwitchWidget extends StatelessWidget {
  const LanguageToggleSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)?.locale ?? context.locale;
    final isArabic = currentLocale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: const Color(0xFFC7CFDC),
          width: 1.2,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(
              context: context,
              flagAsset: ImageAssets.ar,
              label: 'عربي',
              isSelected: isArabic,
              onTap: () async {
                if (!isArabic) {
                  await context.setLocale(const Locale('ar'));
                }
              },
            ),
            VerticalDivider(
              color: const Color(0xFFC7CFDC),
              thickness: 1.2,
              width: 12.w,
              indent: 4.h,
              endIndent: 4.h,
            ),
            _buildOption(
              context: context,
              flagAsset: ImageAssets.en,
              label: 'En',
              isSelected: !isArabic,
              onTap: () async {
                if (isArabic) {
                  await context.setLocale(const Locale('en'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String flagAsset,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final selectedBgColor = ColorManager.primary.withOpacity(0.12);
    final selectedBorderColor = ColorManager.primary.withOpacity(0.35);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? selectedBorderColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'En') ...[
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.black,
                ),
              ),
              SizedBox(width: 6.w),
              ClipOval(
                child: Image.asset(
                  flagAsset,
                  width: 22.w,
                  height: 22.h,
                  fit: BoxFit.cover,
                ),
              ),
            ] else ...[
              ClipOval(
                child: Image.asset(
                  flagAsset,
                  width: 22.w,
                  height: 22.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}