import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/resources/assets_manager.dart';
import 'cubit/location_cubit.dart';
import 'cubit/location_states.dart';
import 'widgets/map_address_bottom_sheet.dart';
import 'widgets/map_back_button.dart';
import 'widgets/map_locate_me_button.dart';

class SelectedLocationModel {
  final String address;
  final double latitude;
  final double longitude;

  const SelectedLocationModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class MapScreen extends StatefulWidget {
  final bool showCloseButton;

  const MapScreen({
    super.key,
    this.showCloseButton = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _centerPosition = const LatLng(30.0444, 31.2357);
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LocationCubit>().fetchCurrentLocation();
      }
    });
  }

  void _animateToPosition(LatLng position) {
    _centerPosition = position;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, 16.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocListener<LocationCubit, LocationStates>(
            listener: (context, state) {
              if (state is LocationSuccessState) {
                _isInitialLoad = false;
                _animateToPosition(state.position);
              } else if (state is LocationErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _centerPosition,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;

                final currentState = context.read<LocationCubit>().state;
                if (currentState is LocationSuccessState) {
                  _animateToPosition(currentState.position);
                }
              },
              onCameraIdle: () {
                if (!_isInitialLoad) {
                  context.read<LocationCubit>().updateAddressFromMap(
                    _centerPosition.latitude,
                    _centerPosition.longitude,
                  );
                }
              },
              onCameraMove: (position) => _centerPosition = position.target,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Image.asset(ImageAssets.here, width: 45, height: 45),
            ),
          ),

          MapBackButton(isCloseIcon: widget.showCloseButton),

          MapLocateMeButton(
            onPressed: () =>
                context.read<LocationCubit>().fetchCurrentLocation(),
          ),

          MapAddressBottomSheet(
            getCenterPosition: () => _centerPosition,
          ),
        ],
      ),
    );
  }
}