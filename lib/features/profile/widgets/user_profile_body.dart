import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../domain/entities/user_profile_entity.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routes_manager/routes.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../cart/pages/my_orders_screen.dart';
import '../../favourites/cubit/favourites_cubit.dart';
import '../../favourites/cubit/favourites_states.dart';
import '../../favourites/favourites_screen.dart';
import '../../location/cubit/location_cubit.dart';
import '../../location/cubit/location_states.dart';
import '../../main_layout/cubit/main_layout_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../screens/saved_addresses_screen.dart';
import 'language_toggle_switch_widget.dart';
import 'logout_bottom_sheet_widget.dart';
import 'profile_setting_item.dart';
import 'user_header_widget.dart';

class UserProfileBody extends StatelessWidget {
  final UserProfileEntity userProfile;

  const UserProfileBody({super.key, required this.userProfile});

  int _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid.hashCode.abs();
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserHeaderWidget(userName: userProfile.name),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _buildSectionTitle("account_details".tr()),
                SizedBox(height: 10.h),
                _buildAccountDetailsCard(context),
                SizedBox(height: 20.h),
                _buildSectionTitle("system_settings".tr()),
                SizedBox(height: 10.h),
                _buildSystemSettingsCard(context),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.black,
      ),
    );
  }

  Widget _buildAccountDetailsCard(BuildContext context) {
    final int userId = _getCurrentUserId();

    return Container(
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
            iconPath: SvgAssets.account_info,
            title: "account_info".tr(),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.accountInfoScreen,
                arguments: userProfile,
              );
            },
            trailing: Text(
              userProfile.email,
              style: TextStyle(color: ColorManager.black, fontSize: 13.sp),
            ),
          ),
          const Divider(height: 1),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              final ordersCount = snapshot.hasData
                  ? snapshot.data!.docs.length
                  : 0;

              return ProfileSettingItem(
                iconPath: SvgAssets.my_orders,
                title: "my_orders".tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<MainLayoutCubit>(),
                        child: const MyOrdersScreen(),
                      ),
                    ),
                  );
                },
                trailing: _buildBadgeAvatar("$ordersCount"),
              );
            },
          ),
          const Divider(height: 1),
          BlocBuilder<LocationCubit, LocationStates>(
            builder: (context, state) {
              final addressesCount = context
                  .watch<LocationCubit>()
                  .savedAddresses
                  .length;

              return ProfileSettingItem(
                iconPath: SvgAssets.saved_addresses,
                title: "saved_addresses".tr(),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<LocationCubit>(),
                        child: const SavedAddressesScreen(),
                      ),
                    ),
                  );
                  if (context.mounted) {
                    context.read<LocationCubit>().getSavedAddresses();
                  }
                },
                trailing: _buildBadgeAvatar("$addressesCount"),
              );
            },
          ),
          const Divider(height: 1),
          BlocBuilder<FavouritesCubit, FavouritesStates>(
            builder: (context, state) {
              final favCount = context
                  .read<FavouritesCubit>()
                  .favoriteIds
                  .length;

              return ProfileSettingItem(
                iconPath: SvgAssets.favourites,
                title: "favourites".tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouritesScreen(),
                    ),
                  );
                },
                trailing: _buildBadgeAvatar("$favCount"),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettingsCard(BuildContext context) {
    return Container(
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
            title:"call_us".tr(),
            onTap: () {
              getIt<UrlLauncherService>().makePhoneCall('19585');
            },
          ),
          const Divider(height: 1),
          ProfileSettingItem(
            iconPath: SvgAssets.lastTrySvgLogo,
            title: "about_koki".tr(),
            onTap: () {},
          ),
          const Divider(height: 1),
          ProfileSettingItem(
            iconPath: SvgAssets.logout,
            title: "log_out".tr(),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => LogoutBottomSheetWidget(
                  onConfirm: () {
                    BlocProvider.of<ProfileCubit>(context).logOutUser();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeAvatar(String text) {
    return CircleAvatar(
      radius: 12.r,
      backgroundColor: ColorManager.lightGrey,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: ColorManager.darkSlate,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
