import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/address_entity.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_states.dart';
import '../map_screen.dart';
import '../widgets/address_form_fields.dart';
import '../widgets/address_header_widget.dart';
import '../widgets/address_submit_button.dart';
import '../widgets/location_picker_card.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressEntity? addressToEdit;

  const AddEditAddressScreen({super.key, this.addressToEdit});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _labelController;
  late final TextEditingController _phoneController;
  late final TextEditingController _secondaryPhoneController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;

  final ValueNotifier<String?> _selectedAddressDetailsNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);

  double? _lat;
  double? _lon;
  GoogleMapController? _miniMapController;

  bool get _isEdit => widget.addressToEdit != null;

  @override
  void initState() {
    super.initState();
    final address = widget.addressToEdit;

    _labelController = TextEditingController(text: address?.label ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _secondaryPhoneController = TextEditingController(text: address?.secondaryPhone ?? '');
    _buildingController = TextEditingController(text: address?.buildingNo ?? '');
    _floorController = TextEditingController(text: address?.floorNo ?? '');

    if (address != null) {
      _selectedAddressDetailsNotifier.value = address.addressDetails;
      _lat = address.lat;
      _lon = address.lon;
    }

    _labelController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _secondaryPhoneController.addListener(_validateForm);
    _buildingController.addListener(_validateForm);
    _floorController.addListener(_validateForm);
    _selectedAddressDetailsNotifier.addListener(_validateForm);

    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
  }

  void _validateForm() {
    final isPhoneValid = RegExp(r'^01[0125][0-9]{8}$').hasMatch(_phoneController.text.trim());
    final secPhone = _secondaryPhoneController.text.trim();
    final isSecPhoneValid = secPhone.isEmpty || RegExp(r'^01[0125][0-9]{8}$').hasMatch(secPhone);

    _isFormValidNotifier.value = _selectedAddressDetailsNotifier.value != null &&
        _labelController.text.trim().isNotEmpty &&
        isPhoneValid &&
        isSecPhoneValid &&
        _buildingController.text.trim().isNotEmpty &&
        _floorController.text.trim().isNotEmpty;
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      final addressEntity = AddressEntity(
        id: widget.addressToEdit?.id ?? '',
        label: _labelController.text.trim(),
        addressDetails: _selectedAddressDetailsNotifier.value!,
        phone: _phoneController.text.trim(),
        secondaryPhone: _secondaryPhoneController.text.trim(),
        buildingNo: _buildingController.text.trim(),
        floorNo: _floorController.text.trim(),
        lat: _lat ?? 0.0,
        lon: _lon ?? 0.0,
      );

      if (_isEdit) {
        context.read<LocationCubit>().updateAddress(addressEntity);
      } else {
        context.read<LocationCubit>().addNewAddress(addressEntity);
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _phoneController.dispose();
    _secondaryPhoneController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _selectedAddressDetailsNotifier.dispose();
    _isFormValidNotifier.dispose();
    _miniMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationStates>(
      listener: (context, state) {
        if (state is AddressActionSuccessState) {
          final message = _isEdit
              ? "address_updated_success".tr()
              : "address_added_success".tr();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.pop(context);
        } else if (state is LocationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("could_not_fetch_location".tr())),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AddressHeaderWidget(
                title: _isEdit ? "edit_address".tr() : "add_new_address".tr(),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ValueListenableBuilder<String?>(
                        valueListenable: _selectedAddressDetailsNotifier,
                        builder: (context, addressDetails, _) {
                          return LocationPickerCard(
                            lat: _lat,
                            lon: _lon,
                            addressDetails: addressDetails,
                            onMapCreated: (controller) =>
                            _miniMapController = controller,
                            onZoomIn: () => _miniMapController
                                ?.animateCamera(CameraUpdate.zoomIn()),
                            onZoomOut: () => _miniMapController
                                ?.animateCamera(CameraUpdate.zoomOut()),
                            onTap: () => _navigateToMapScreen(context),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      AddressFormFields(
                        labelController: _labelController,
                        phoneController: _phoneController,
                        secondaryPhoneController: _secondaryPhoneController,
                        buildingController: _buildingController,
                        floorController: _floorController,
                      ),
                      SizedBox(height: 28.h),
                      AddressSubmitButton(
                        isEdit: _isEdit,
                        isFormValidNotifier: _isFormValidNotifier,
                        onSubmit: _onSavePressed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToMapScreen(BuildContext context) async {
    final cubit = context.read<LocationCubit>();
    final result = await Navigator.push<SelectedLocationModel>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const MapScreen(),
        ),
      ),
    );

    if (result != null) {
      _selectedAddressDetailsNotifier.value = result.address;
      _lat = result.latitude;
      _lon = result.longitude;

      _miniMapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(_lat!, _lon!), 15),
      );
    }
  }
}