import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../domain/entities/address_entity.dart';
import 'address_card_item.dart';

class SavedAddressesListWidget extends StatelessWidget {
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final Function(AddressEntity) onEditAddress;
  final Function(String) onDeleteAddress;
  final VoidCallback onAddNewAddress;

  const SavedAddressesListWidget({
    super.key,
    required this.addresses,
    this.selectedAddress,
    required this.onEditAddress,
    required this.onDeleteAddress,
    required this.onAddNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "saved_addresses_title".tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addresses.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final address = addresses[index];

              final isSelected = selectedAddress != null &&
                  ((selectedAddress!.id.isNotEmpty && selectedAddress!.id == address.id) ||
                      selectedAddress!.addressDetails.trim() == address.addressDetails.trim());

              return AddressCardItem(
                address: address,
                isSelected: isSelected,
                onEdit: () => onEditAddress(address),
                onDelete: () => onDeleteAddress(address.id),
              );
            },
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: onAddNewAddress,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_location_alt_outlined,
                  color: ColorManager.primary,
                  size: 22.sp,
                ),
                SizedBox(width: 8.w),
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
        ],
      ),
    );
  }
}