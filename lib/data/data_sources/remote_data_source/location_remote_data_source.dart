import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koki/core/error/exceptions.dart';

import '../../model/address_model.dart';

abstract class LocationRemoteDataSource {
  Future<String> getAddressFromCoords(double lat, double lon);
  Future<LatLng> getUserPosition();
  Future<void> saveAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);
  Future<List<AddressModel>> getSavedAddresses();
  Future<void> deleteAddress(String addressId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  static const LatLng _defaultFallbackLocation = LatLng(30.0444, 31.2357);

  LocationRemoteDataSourceImpl({
    required this.dio,
    required this.firestore,
    required this.firebaseAuth,
  });

  String get _currentUserId {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException("User is not logged in");
    }
    return user.uid;
  }

  CollectionReference get _userAddressesRef => firestore
      .collection('users')
      .doc(_currentUserId)
      .collection('addresses');

  @override
  Future<String> getAddressFromCoords(double lat, double lon) async {
    try {
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lon,
          'zoom': 19,
          'addressdetails': 1,
        },
        options: Options(
          headers: {
            'User-Agent': 'KokiApp/1.0',
            'Accept-Language': 'en',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final addressData = response.data['address'];

        if (addressData != null) {
          final String road = addressData['road'] ?? addressData['pedestrian'] ?? '';
          final String suburb = addressData['suburb'] ?? addressData['neighbourhood'] ?? '';
          final String city = addressData['city'] ?? addressData['town'] ?? addressData['state'] ?? '';

          final List<String> addressParts = [];
          if (road.isNotEmpty) addressParts.add(road);
          if (suburb.isNotEmpty) addressParts.add(suburb);
          if (city.isNotEmpty) addressParts.add(city);

          if (addressParts.isNotEmpty) {
            return addressParts.join(', ');
          }
        }

        return response.data['display_name'] ?? 'Unknown Location';
      }
      throw const LocationException('Failed to fetch address details');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.error.toString().contains('SocketException')) {
        throw const NetworkException('Network error. Please check your internet connection.');
      }
      throw LocationException('Failed to fetch address: ${e.message}');
    } catch (e) {
      if (e is LocationException || e is NetworkException) rethrow;
      throw LocationException('Something went wrong while fetching address: $e');
    }
  }

  @override
  Future<LatLng> getUserPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return _defaultFallbackLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _defaultFallbackLocation;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return _defaultFallbackLocation;
    }
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    try {
      final docRef = _userAddressesRef.doc();
      await docRef.set(address.toJson());
    } catch (e) {
      throw LocationException('Failed to save address: $e');
    }
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    try {
      await _userAddressesRef.doc(address.id).update(address.toJson());
    } catch (e) {
      throw LocationException('Failed to update address: $e');
    }
  }

  @override
  Future<List<AddressModel>> getSavedAddresses() async {
    try {
      final snapshot = await _userAddressesRef.get();
      return snapshot.docs
          .map((doc) => AddressModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw LocationException('Failed to get saved addresses: $e');
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _userAddressesRef.doc(addressId).delete();
    } catch (e) {
      throw LocationException('Failed to delete address: $e');
    }
  }
}