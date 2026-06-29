import 'package:field_track_todo/features/create_location/controller/create_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  final Color inputBorderColor;
  final CreateLocationController controller;
  final ThemeData theme;

  const MapPreview({
    super.key,
    required this.inputBorderColor,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: inputBorderColor, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Obx(
          () => FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: LatLng(
                controller.latitude.value,
                controller.longitude.value,
              ),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.field_track_todo',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(
                      controller.latitude.value,
                      controller.longitude.value,
                    ),
                    radius: controller.radius.value,
                    useRadiusInMeter: true,
                    color: theme.primaryColor.withValues(alpha: 0.15),
                    borderColor: theme.primaryColor,
                    borderStrokeWidth: 2.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      controller.latitude.value,
                      controller.longitude.value,
                    ),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_on,
                      color: theme.primaryColor,
                      size: 38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
