import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../../domain/use_cases/get_user_address_use_case.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/data_sources/local_data_source/location_local_data_source.dart';
import '../../../domain/repository/location_repository.dart';
import 'location_states.dart';

class LocationCubit extends Cubit<LocationStates> {
  final GetUserAddressUseCase getUserAddressUseCase;
  final LocationRepository locationRepository;
  final LocationLocalDataSource localDataSource;
  final FirebaseAuth firebaseAuth;

  LocationCubit({
    required this.getUserAddressUseCase,
    required this.locationRepository,
    required this.localDataSource,
    required this.firebaseAuth,
  }) : super(LocationInitialState());

  List<AddressEntity> _savedAddresses = [];
  List<AddressEntity> get savedAddresses => _savedAddresses;

  AddressEntity? _selectedAddress;
  AddressEntity? get selectedAddress => _selectedAddress;

  AddressEntity? _tempSelectedAddress;
  AddressEntity? get tempSelectedAddress => _tempSelectedAddress;

  bool get isUserLoggedIn => firebaseAuth.currentUser != null;

  void initTempAddress() {
    if (_selectedAddress != null) {
      try {
        _tempSelectedAddress = _savedAddresses.firstWhere(
              (element) =>
          element.id == _selectedAddress!.id ||
              element.addressDetails == _selectedAddress!.addressDetails,
        );
      } catch (_) {
        _tempSelectedAddress = _selectedAddress;
      }
    } else if (_savedAddresses.isNotEmpty) {
      _tempSelectedAddress = _savedAddresses.first;
    } else {
      _tempSelectedAddress = null;
    }

    emit(TempAddressSelectedState(_tempSelectedAddress));
  }

  void setTempAddress(AddressEntity address) {
    _tempSelectedAddress = address;
    emit(TempAddressSelectedState(_tempSelectedAddress));
  }

  Future<void> confirmAddressSelection() async {
    if (_tempSelectedAddress != null) {
      _selectedAddress = _tempSelectedAddress;
      await localDataSource.saveSelectedAddress(_selectedAddress!);
      emit(SavedAddressesSuccessState(List.from(_savedAddresses)));
    }
  }
  Future<void> setSelectedAddressFromHeader(AddressEntity address) async {
    _selectedAddress = address;
    await localDataSource.saveSelectedAddress(address);
    emit(SavedAddressesSuccessState(List.from(_savedAddresses)));
  }

  Future<void> loadSelectedAddress() async {
    _selectedAddress = await localDataSource.getSelectedAddress();
    emit(SavedAddressesSuccessState(_savedAddresses));
  }

  Future<void> selectAddress(AddressEntity address) async {
    _selectedAddress = address;
    await localDataSource.saveSelectedAddress(address);
    emit(SavedAddressesSuccessState(List.from(_savedAddresses)));
  }

  Future<void> fetchCurrentLocation() async {
    emit(LocationLoadingState());
    try {
      final LatLng userPosition = await getUserAddressUseCase.call();
      final String address = await locationRepository.getAddressFromCoords(
        userPosition.latitude,
        userPosition.longitude,
      );

      emit(LocationSuccessState(position: userPosition, address: address));
    } catch (e) {
      if (_selectedAddress != null) {
        emit(SavedAddressesSuccessState(List.from(_savedAddresses)));
      } else {
        emit(LocationErrorState('Could not fetch current location'));
      }
    }
  }

  Future<void> updateAddressFromMap(double lat, double lon) async {
    try {
      final String address = await locationRepository.getAddressFromCoords(lat, lon);
      emit(MapAddressUpdatedState(address: address, lat: lat, lon: lon));
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }

  Future<void> getSavedAddresses() async {
    if (!isUserLoggedIn) return;
    emit(SavedAddressesLoadingState());
    try {
      _savedAddresses = await locationRepository.getSavedAddresses();

      _selectedAddress ??= await localDataSource.getSelectedAddress();

      if (_selectedAddress != null && _savedAddresses.isNotEmpty) {
        final matchIndex = _savedAddresses.indexWhere(
              (e) => (e.id.isNotEmpty && e.id == _selectedAddress!.id) ||
              e.addressDetails.trim() == _selectedAddress!.addressDetails.trim(),
        );

        if (matchIndex != -1) {
          _selectedAddress = _savedAddresses[matchIndex];
        }
      } else if (_selectedAddress == null && _savedAddresses.isNotEmpty) {
        _selectedAddress = _savedAddresses.first;
        await localDataSource.saveSelectedAddress(_selectedAddress!);
      }

      emit(SavedAddressesSuccessState(List.from(_savedAddresses)));
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }

  Future<void> addNewAddress(AddressEntity address) async {
    emit(LocationLoadingState());
    try {
      if (isUserLoggedIn) {
        await locationRepository.saveAddress(address);
        await getSavedAddresses();
        final newlyAdded = _savedAddresses.isNotEmpty ? _savedAddresses.last : address;
        await selectAddress(newlyAdded);
      } else {
        await selectAddress(address);
      }
      emit(AddressActionSuccessState("Address added successfully"));
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }

  Future<void> syncGuestAddressToFirebase() async {
    final guestAddress = await localDataSource.getSelectedAddress();
    if (guestAddress != null && isUserLoggedIn) {
      try {
        await locationRepository.saveAddress(guestAddress);
        await getSavedAddresses();
        if (_savedAddresses.isNotEmpty) {
          await selectAddress(_savedAddresses.last);
        }
      } catch (_) {}
    } else if (isUserLoggedIn) {
      await getSavedAddresses();
    }
  }

  Future<void> updateAddress(AddressEntity address) async {
    emit(LocationLoadingState());
    try {
      await locationRepository.updateAddress(address);
      await getSavedAddresses();
      emit(AddressActionSuccessState("Address updated successfully"));
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await locationRepository.deleteAddress(addressId);
      _savedAddresses.removeWhere((address) => address.id == addressId);
      emit(SavedAddressesSuccessState(List.from(_savedAddresses)));
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }
}