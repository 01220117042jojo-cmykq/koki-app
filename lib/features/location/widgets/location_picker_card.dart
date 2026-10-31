import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koki/core/resources/color_manager.dart';

class LocationPickerCard extends StatelessWidget {
  final double? lat;
  final double? lon;
  final String? addressDetails;
  final Function(GoogleMapController) onMapCreated;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onTap;

  const LocationPickerCard({
    super.key,
    required this.lat,
    required this.lon,
    required this.addressDetails,
    required this.onMapCreated,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidCoordinates = lat != null && lon != null && lat != 0.0 && lon != 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade400, width: 1),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Column(
          children: [
            if (hasValidCoordinates)
              SizedBox(
                height: 150.h,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat!, lon!),
                        zoom: 15,
                      ),
                      onMapCreated: onMapCreated,
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected_loc'),
                          position: LatLng(lat!, lon!),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                    ),
                    Positioned(
                      right: 12.w,
                      bottom: 12.h,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: onZoomIn,
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(Icons.add, size: 20.sp, color: Colors.black87),
                              ),
                            ),
                            const Divider(height: 1, thickness: 1),
                            InkWell(
                              onTap: onZoomOut,
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(Icons.remove, size: 20.sp, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Row(
                  children: [
                    Icon(
                      hasValidCoordinates ? Icons.location_on : Icons.add_location_alt_rounded,
                      color: ColorManager.primary,
                      size: 28.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        addressDetails ?? "select_location_on_map".tr(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: ColorManager.primary, size: 22.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}