import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koki/core/resources/color_manager.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import '../../../../core/widget/custom_elevates_button.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../location/cubit/location_cubit.dart';
import '../../../location/cubit/location_states.dart';
import '../../../location/screens/add_edit_address_screen.dart';

class AddressSelectionBottomSheet extends StatelessWidget {
  const AddressSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>()..initTempAddress();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "which_address_would_you_like_to_use".tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: BlocBuilder<LocationCubit, LocationStates>(
              builder: (context, state) {
                final addresses = cubit.savedAddresses;
                final tempSelected = cubit.tempSelectedAddress;

                if (state is SavedAddressesLoadingState) {
                  return SizedBox(
                    height: 120.h,
                    child: const Center(
                      child: CustomLoadingIndicator(size: 40.0),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final address = addresses[index];

                    final isSelected =
                        tempSelected != null &&
                        ((tempSelected.id.isNotEmpty &&
                                tempSelected.id == address.id) ||
                            tempSelected.addressDetails.trim() ==
                                address.addressDetails.trim());

                    return _AddressCardItem(
                      address: address,
                      isSelected: isSelected,
                      onTap: () => cubit.setTempAddress(address),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const AddEditAddressScreen(),
                  ),
                ),
              );
              if (result == true) {
                await cubit.getSavedAddresses();
                if (cubit.savedAddresses.isNotEmpty) {
                  final newAddress = cubit.savedAddresses.last;
                  cubit.setTempAddress(newAddress);
                  await cubit.confirmAddressSelection();
                }
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.add_location_alt_outlined,
                  color: ColorManager.primary,
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "add_new_address".tr(),
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              label: "continue".tr(),
              onTap: () async {
                await cubit.confirmAddressSelection();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCardItem extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressCardItem({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EEF9) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? ColorManager.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? ColorManager.primary : Colors.grey,
              size: 22.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address.addressDetails,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
