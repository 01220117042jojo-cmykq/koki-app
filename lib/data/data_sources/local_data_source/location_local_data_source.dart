import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/address_entity.dart';

abstract class LocationLocalDataSource {
  Future<void> saveSelectedAddress(AddressEntity address);
  Future<AddressEntity?> getSelectedAddress();
  Future<void> clearGuestAddress();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _selectedAddressKey = 'CACHED_SELECTED_ADDRESS';

  LocationLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveSelectedAddress(AddressEntity address) async {
    final map = {
      'id': address.id,
      'label': address.label,
      'addressDetails': address.addressDetails,
      'phone': address.phone,
      'secondaryPhone': address.secondaryPhone,
      'buildingNo': address.buildingNo,
      'floorNo': address.floorNo,
      'lat': address.lat,
      'lon': address.lon,
    };
    await sharedPreferences.setString(_selectedAddressKey, jsonEncode(map));
  }

  @override
  Future<AddressEntity?> getSelectedAddress() async {
    final jsonString = sharedPreferences.getString(_selectedAddressKey);
    if (jsonString != null) {
      final Map<String, dynamic> map = jsonDecode(jsonString);
      return AddressEntity(
        id: map['id'] ?? '',
        label: map['label'] ?? 'Home',
        addressDetails: map['addressDetails'] ?? '',
        phone: map['phone'] ?? '',
        secondaryPhone: map['secondaryPhone'] ?? '',
        buildingNo: map['buildingNo'] ?? '',
        floorNo: map['floorNo'] ?? '',
        lat: (map['lat'] as num).toDouble(),
        lon: (map['lon'] as num).toDouble(),
      );
    }
    return null;
  }

  @override
  Future<void> clearGuestAddress() async {
    await sharedPreferences.remove(_selectedAddressKey);
  }
}