class AddressEntity {
  final String id;
  final String label;
  final String addressDetails;
  final String phone;
  final String? secondaryPhone;
  final String buildingNo;
  final String floorNo;
  final double lat;
  final double lon;

  AddressEntity({
    required this.id,
    required this.label,
    required this.addressDetails,
    required this.phone,
    this.secondaryPhone,
    required this.buildingNo,
    required this.floorNo,
    required this.lat,
    required this.lon,
  });
}