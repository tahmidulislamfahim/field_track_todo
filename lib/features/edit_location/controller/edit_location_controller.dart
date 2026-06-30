import 'package:field_track_todo/features/edit_location/service/edit_location_service.dart';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  final EditLocationService _editLocationService = Get.put(EditLocationService());

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

  Future<void> saveLocation() async {
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

    EasyLoading.show(status: 'Updating location...');

    try {
      final response = await _editLocationService.updateLocation(
        locationId: originalLocation.id,
        name: name,
        latitude: lat,
        longitude: lng,
        radiusM: radius.value,
        isActive: isActive.value,
      );

      if (response.status.isOk) {
        final locationsController = Get.find<LocationsController>();
        await locationsController.getLocations();

        EasyLoading.showSuccess('Location updated successfully');
        Get.back();
      } else {
        String errorMsg = 'Could not update location. Please try again.';
        if (response.body != null && response.body is Map) {
          errorMsg = response.body['message'] ?? errorMsg;
        }
        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      EasyLoading.showError('An unexpected error occurred.');
    }
  }

  Future<void> deleteLocation() async {
    EasyLoading.show(status: 'Deleting location...');

    try {
      final response = await _editLocationService.deleteLocation(originalLocation.id);

      if (response.status.isOk) {
        final locationsController = Get.find<LocationsController>();
        await locationsController.getLocations();

        EasyLoading.showSuccess('Location deleted successfully');
        Get.back();
      } else {
        String errorMsg = 'Could not delete location. Please try again.';
        if (response.body != null && response.body is Map) {
          errorMsg = response.body['message'] ?? errorMsg;
        }
        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      EasyLoading.showError('An unexpected error occurred.');
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

