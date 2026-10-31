import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/address_entity.dart';

abstract class LocationStates {}

class LocationInitialState extends LocationStates {}

class LocationLoadingState extends LocationStates {}

class LocationSuccessState extends LocationStates {
  final LatLng position;
  final String address;

  LocationSuccessState({required this.position, required this.address});
}

class MapAddressUpdatedState extends LocationStates {
  final String address;
  final double lat;
  final double lon;

  MapAddressUpdatedState({
    required this.address,
    required this.lat,
    required this.lon,
  });
}

class LocationErrorState extends LocationStates {
  final String errorMessage;

  LocationErrorState(this.errorMessage);
}

class SavedAddressesLoadingState extends LocationStates {}

class SavedAddressesSuccessState extends LocationStates {
  final List<AddressEntity> addresses;

  SavedAddressesSuccessState(this.addresses);
}

class AddressActionSuccessState extends LocationStates {
  final String message;

  AddressActionSuccessState(this.message);
}
class TempAddressSelectedState extends LocationStates {
  final AddressEntity? tempSelectedAddress;
  TempAddressSelectedState(this.tempSelectedAddress);
}