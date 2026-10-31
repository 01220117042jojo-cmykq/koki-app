import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/core/widget/custom_loading_indicator.dart';
import 'package:koki/features/location/cubit/location_states.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/network/cubit/network_cubit.dart';
import '../../../core/network/cubit/network_state.dart';
import '../../../core/network/widget/offline_empty_state.dart';
import '../../../domain/entities/address_entity.dart';
import '../../location/cubit/location_cubit.dart';
import '../../location/screens/add_edit_address_screen.dart';
import '../../location/widgets/address_header_widget.dart';
import '../../location/widgets/delete_address_bottom_sheet.dart';
import '../widgets/empty_addresses_widget.dart';
import '../widgets/saved_addresses_list_widget.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<LocationCubit>()..getSavedAddresses(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<NetworkCubit, NetworkState>(
          builder: (context, networkState) {
            if (networkState is NetworkDisconnected) {
              return OfflineEmptyStateWidget(
                viewType: OfflineViewType.dog,
                onRetrySuccess: () {
                  context.read<LocationCubit>().getSavedAddresses();
                },
              );
            }

            return Column(
              children: [
                const AddressHeaderWidget(title: 'My Addresses'),
                Expanded(
                  child: BlocConsumer<LocationCubit, LocationStates>(
                    listener: (context, state) {
                      if (state is LocationErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final cubit = context.read<LocationCubit>();

                      if (state is SavedAddressesLoadingState) {
                        return const Center(
                          child: CustomLoadingIndicator(),
                        );
                      }

                      if (cubit.savedAddresses.isEmpty) {
                        return EmptyAddressesWidget(
                          onAddAddressPressed: () =>
                              openAddEditAddressScreen(context),
                        );
                      }

                      return SavedAddressesListWidget(
                        addresses: cubit.savedAddresses,
                        selectedAddress: cubit.selectedAddress,
                        onEditAddress: (address) => openAddEditAddressScreen(
                          context,
                          addressToEdit: address,
                        ),
                        onDeleteAddress: (addressId) =>
                            _showDeleteConfirmationDialog(
                              context,
                              addressId,
                            ),
                        onAddNewAddress: () =>
                            openAddEditAddressScreen(context),
                      );
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

  void _showDeleteConfirmationDialog(BuildContext context, String addressId) {
    final cubit = context.read<LocationCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DeleteAddressBottomSheet(
        onDeletePressed: () {
          cubit.deleteAddress(addressId);
        },
      ),
    );
  }

  Future<void> openAddEditAddressScreen(
      BuildContext context, {
        AddressEntity? addressToEdit,
      }) async {
    final cubit = context.read<LocationCubit>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AddEditAddressScreen(addressToEdit: addressToEdit),
        ),
      ),
    );

    if (result == true) {
      await cubit.getSavedAddresses();
      if (addressToEdit == null && cubit.savedAddresses.isNotEmpty) {
        await cubit.selectAddress(cubit.savedAddresses.last);
      }
    }
  }
}