import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/url_launcher_service.dart';
import 'guest_avatar_widget.dart';
import 'language_toggle_switch_widget.dart';
import 'profile_header_widget.dart';
import 'profile_setting_item.dart';

class GuestProfileBody extends StatelessWidget {
  const GuestProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeaderWidget(
            content: Column(
              children: [
                const GuestAvatarWidget(),
                SizedBox(height: 12.h),
                Text(
                  "hello_there".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "not_signed_in_msg".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "system_settings".tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ProfileSettingItem(
                        iconPath: SvgAssets.language,
                        title: "language".tr(),
                        onTap: () {},
                        trailing: const LanguageToggleSwitchWidget(),
                      ),
                      const Divider(height: 1),
                      ProfileSettingItem(
                        iconPath: SvgAssets.call,
                        title: "call_us".tr(),
                        onTap: () {
                          getIt<UrlLauncherService>().makePhoneCall('19585');
                        },
                      ),
                      const Divider(height: 1),
                      ProfileSettingItem(
                        iconPath: SvgAssets.about,
                        title: "about_koki".tr(),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}