import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../core/widget/custom_elevates_button.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_states.dart';
import '../map_screen.dart';

class MapAddressBottomSheet extends StatefulWidget {
  final LatLng Function() getCenterPosition;

  const MapAddressBottomSheet({super.key, required this.getCenterPosition});

  @override
  State<MapAddressBottomSheet> createState() => _MapAddressBottomSheetState();
}

class _MapAddressBottomSheetState extends State<MapAddressBottomSheet> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BlocBuilder<LocationCubit, LocationStates>(
          builder: (context, state) {
            String currentAddress = "loading_address".tr();
            bool isLoading = false;

            if (state is LocationLoadingState) {
              isLoading = true;
            } else if (state is LocationSuccessState) {
              currentAddress = state.address;
            } else if (state is MapAddressUpdatedState) {
              currentAddress = state.address;
            } else if (state is LocationErrorState) {
              currentAddress = "could_not_fetch_address".tr();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: ColorManager.primary,
                      size: 24.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        currentAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isLoading ? Colors.grey : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    label: "confirm_location".tr(),
                    onTap: ()async {
                      if (_isNavigating) return;

                      if (!isLoading &&
                          currentAddress != "loading_address".tr() &&
                          currentAddress != "could_not_fetch_address".tr()) {
                        _isNavigating = true;

                        final centerPos = widget.getCenterPosition();
                        await context.read<LocationCubit>().confirmAddressSelection();
                        final result = SelectedLocationModel(
                          address: currentAddress,
                          latitude: centerPos.latitude,
                          longitude: centerPos.longitude,
                        );

                        if (Navigator.canPop(context)) {
                          Navigator.pop(context, result);
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}