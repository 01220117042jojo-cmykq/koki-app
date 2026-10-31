import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repository/location_repository.dart';
import '../data_sources/remote_data_source/location_remote_data_source.dart';
import '../model/address_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<LatLng> getUserPosition() async {
    return await remoteDataSource.getUserPosition();
  }

  @override
  Future<String> getAddressFromCoords(double lat, double lon) async {
    return await remoteDataSource.getAddressFromCoords(lat, lon);
  }

  @override
  Future<void> saveAddress(AddressEntity address) async {
    final model = AddressModel.fromEntity(address);
    await remoteDataSource.saveAddress(model);
  }

  @override
  Future<void> updateAddress(AddressEntity address) async {
    final model = AddressModel.fromEntity(address);
    await remoteDataSource.updateAddress(model);
  }

  @override
  Future<List<AddressEntity>> getSavedAddresses() async {
    return await remoteDataSource.getSavedAddresses();
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await remoteDataSource.deleteAddress(addressId);
  }
}