import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/location_repository.dart';

class GetUserPositionUseCase {
  final LocationRepository repository;

  GetUserPositionUseCase(this.repository);

  Future<LatLng> call() async {
    return await repository.getUserPosition();
  }
}