import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/widget/top_network_banner.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../location/cubit/location_cubit.dart';
import '../../../location/cubit/location_states.dart';
import '../../../location/map_screen.dart';
import '../cubit/home_cubit.dart';
import '../pages/search_screen.dart';
import 'address_selection_bottom_sheet.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final locationCubit = getIt<LocationCubit>();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: statusBarHeight + 25.h,
            left: 16.w,
            right: 16.w,
            bottom: 4.h,
          ),
          color: ColorManager.primaryDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<LocationCubit, LocationStates>(
                bloc: locationCubit,
                builder: (context, state) {
                  final selectedAddr = locationCubit.selectedAddress;

                  return GestureDetector(
                    onTap: () => _handleAddressTap(context, locationCubit),
                    child: selectedAddr == null
                        ? const _NoLocationSelectedWidget()
                        : _LocationSelectedWidget(
                      address: selectedAddr.addressDetails,
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              const _HomeSearchBarWidget(),
            ],
          ),
        ),
        Image.asset(
          ImageAssets.frame_home,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ],
    );
  }

  Future<void> _handleAddressTap(
      BuildContext context,
      LocationCubit locationCubit,
      ) async {
    final isConnected =
    await context.read<NetworkCubit>().checkConnection();
    if (!isConnected) {
      if (context.mounted) {
        TopNetworkBanner.show(context);
      }
      return;
    }

    if (!context.mounted) return;

    if (locationCubit.isUserLoggedIn) {
      locationCubit.getSavedAddresses();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider.value(
          value: locationCubit,
          child: const AddressSelectionBottomSheet(),
        ),
      );
    } else {
      _navigateToMapAndSaveLocation(context, locationCubit);
    }
  }

  Future<void> _navigateToMapAndSaveLocation(
      BuildContext context,
      LocationCubit locationCubit,
      ) async {
    final dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: locationCubit,
          child: const MapScreen(),
        ),
      ),
    );

    if (result != null && result is SelectedLocationModel) {
      final autoSavedAddress = AddressEntity(
        id: '',
        label: 'Home',
        addressDetails: result.address,
        phone: '',
        secondaryPhone: '',
        buildingNo: '1',
        floorNo: '1',
        lat: result.latitude,
        lon: result.longitude,
      );

      locationCubit.addNewAddress(autoSavedAddress);
    }
  }
}

class _NoLocationSelectedWidget extends StatelessWidget {
  const _NoLocationSelectedWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, color: ColorManager.white, size: 20.sp),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              "no_selected_location_yet".tr(),
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                  "click_here_to_pick_location".tr(),
                style: TextStyle(color: Colors.white70, fontSize: 10.sp),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: ColorManager.white,
            size: 14.sp,
          ),
        ],
      ),
    );
  }
}

class _LocationSelectedWidget extends StatelessWidget {
  final String address;

  const _LocationSelectedWidget({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
        "delivery_to".tr(),
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorManager.white,
              size: 20.sp,
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeSearchBarWidget extends StatelessWidget {
  const _HomeSearchBarWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final isConnected =
        await context.read<NetworkCubit>().checkConnection();
        if (!isConnected) {
          if (context.mounted) {
            TopNetworkBanner.show(context);
          }
          return;
        }

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HomeCubit>(),
                child: const SearchScreen(),
              ),
            ),
          );
        }
      },
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                  "search_here".tr(),
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}