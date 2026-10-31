import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.id,
    required super.label,
    required super.addressDetails,
    required super.phone,
    super.secondaryPhone,
    required super.buildingNo,
    required super.floorNo,
    required super.lat,
    required super.lon,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json, String id) {
    return AddressModel(
      id: id,
      label: json['label'] ?? '',
      addressDetails: json['addressDetails'] ?? '',
      phone: json['phone'] ?? '',
      secondaryPhone: json['secondaryPhone'],
      buildingNo: json['buildingNo'] ?? '',
      floorNo: json['floorNo'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'addressDetails': addressDetails,
      'phone': phone,
      'secondaryPhone': secondaryPhone,
      'buildingNo': buildingNo,
      'floorNo': floorNo,
      'lat': lat,
      'lon': lon,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      label: entity.label,
      addressDetails: entity.addressDetails,
      phone: entity.phone,
      secondaryPhone: entity.secondaryPhone,
      buildingNo: entity.buildingNo,
      floorNo: entity.floorNo,
      lat: entity.lat,
      lon: entity.lon,
    );
  }
}
