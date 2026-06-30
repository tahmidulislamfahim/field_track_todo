import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class EditLocationController extends GetxController {
  late LocationModel originalLocation;

  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final radius = 150.0.obs;
  final isActive = true.obs;

  final latitude = 25.2048.obs;
  final longitude = 55.2708.obs;

  final MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    originalLocation = Get.arguments as LocationModel;

    nameController.text = originalLocation.name;
    latitudeController.text = originalLocation.latitude.toString();
    longitudeController.text = originalLocation.longitude.toString();
    radius.value = originalLocation.radius;
    isActive.value = originalLocation.isActive;

    latitude.value = originalLocation.latitude;
    longitude.value = originalLocation.longitude;

    latitudeController.addListener(_onLatitudeChanged);
    longitudeController.addListener(_onLongitudeChanged);
  }

  void _onLatitudeChanged() {
    final val = double.tryParse(latitudeController.text);
    if (val != null && val != latitude.value) {
      latitude.value = val;
      _moveMap();
    }
  }

  void _onLongitudeChanged() {
    final val = double.tryParse(longitudeController.text);
    if (val != null && val != longitude.value) {
      longitude.value = val;
      _moveMap();
    }
  }

  void _moveMap() {
    try {
      mapController.move(LatLng(latitude.value, longitude.value), 15.0);
    } catch (_) {}
  }

  void updateRadius(double value) {
    radius.value = value;
  }

  void toggleActive(bool value) {
    isActive.value = value;
  }

  void saveLocation() {
    final name = nameController.text.trim();
    final lat = double.tryParse(latitudeController.text);
    final lng = double.tryParse(longitudeController.text);

    if (name.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a location name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (lat == null) {
      Get.snackbar(
        'Error',
        'Please enter a valid latitude',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (lng == null) {
      Get.snackbar(
        'Error',
        'Please enter a valid longitude',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final updatedLoc = originalLocation.copyWith(
      id: originalLocation.id,
      locationName: name,
      latitude: lat,
      longitude: lng,
      radiusM: radius.value,
      isActive: isActive.value,
    );

    try {
      final locationsController = Get.find<LocationsController>();
      locationsController.updateLocation(updatedLoc);

      Get.back();
      Get.snackbar(
        'Success',
        'Location updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update location.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void deleteLocation() {
    try {
      final locationsController = Get.find<LocationsController>();
      locationsController.deleteLocation(originalLocation.id);

      Get.back();
      Get.snackbar(
        'Success',
        'Location deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete location.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    latitudeController.removeListener(_onLatitudeChanged);
    longitudeController.removeListener(_onLongitudeChanged);
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}
