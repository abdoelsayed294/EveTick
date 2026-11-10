import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/location/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventMapPreview extends StatelessWidget {
  const EventMapPreview({super.key, required this.coordinates, this.title});

  final LocationModel? coordinates;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final coords = coordinates;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 180.h,
        width: double.infinity,
        child: coords == null
            ? ColoredBox(
                color: context.colors.lightBlue,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(coords.latitude, coords.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('event'),
                    position: LatLng(coords.latitude, coords.longitude),
                    infoWindow: InfoWindow(title: title),
                  ),
                },
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
              ),
      ),
    );
  }
}
