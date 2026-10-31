import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/address_entity.dart';

abstract class LocationRepository {
  Future<LatLng> getUserPosition();
  Future<String> getAddressFromCoords(double lat, double lon);
  Future<void> saveAddress(AddressEntity address);
  Future<void> updateAddress(AddressEntity address);
  Future<List<AddressEntity>> getSavedAddresses();
  Future<void> deleteAddress(String addressId);
}