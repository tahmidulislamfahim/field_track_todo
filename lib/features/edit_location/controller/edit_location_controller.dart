import 'package:field_track_todo/features/edit_location/service/edit_location_service.dart';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:field_track_todo/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final editLocationControllerProvider = ChangeNotifierProvider.autoDispose.family<EditLocationController, LocationModel>((ref, originalLocation) {
  return EditLocationController(ref, originalLocation);
});

class EditLocationController extends ChangeNotifier {
  final Ref ref;
  final LocationModel originalLocation;

  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  double radius = 150.0;
  bool isActive = true;

  double latitude = 25.2048;
  double longitude = 55.2708;

  final MapController mapController = MapController();
  final EditLocationService _editLocationService = EditLocationService();

  EditLocationController(this.ref, this.originalLocation) {
    nameController.text = originalLocation.name;
    latitudeController.text = originalLocation.latitude.toString();
    longitudeController.text = originalLocation.longitude.toString();
    radius = originalLocation.radius;
    isActive = originalLocation.isActive;

    latitude = originalLocation.latitude;
    longitude = originalLocation.longitude;

    latitudeController.addListener(_onLatitudeChanged);
    longitudeController.addListener(_onLongitudeChanged);
  }

  void _onLatitudeChanged() {
    final val = double.tryParse(latitudeController.text);
    if (val != null && val != latitude) {
      latitude = val;
      _moveMap();
      notifyListeners();
    }
  }

  void _onLongitudeChanged() {
    final val = double.tryParse(longitudeController.text);
    if (val != null && val != longitude) {
      longitude = val;
      _moveMap();
      notifyListeners();
    }
  }

  void _moveMap() {
    try {
      mapController.move(LatLng(latitude, longitude), 15.0);
    } catch (_) {}
  }

  void updateRadius(double value) {
    radius = value;
    notifyListeners();
  }

  void toggleActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  Future<void> saveLocation() async {
    final name = nameController.text.trim();
    final lat = double.tryParse(latitudeController.text);
    final lng = double.tryParse(longitudeController.text);

    if (name.isEmpty) {
      EasyLoading.showError('Please enter a location name');
      return;
    }
    if (lat == null) {
      EasyLoading.showError('Please enter a valid latitude');
      return;
    }
    if (lng == null) {
      EasyLoading.showError('Please enter a valid longitude');
      return;
    }

    EasyLoading.show(status: 'Updating location...');

    try {
      final response = await _editLocationService.updateLocation(
        locationId: originalLocation.id,
        name: name,
        latitude: lat,
        longitude: lng,
        radiusM: radius,
        isActive: isActive,
      );

      if (response.status.isOk) {
        final locationsController = ref.read(locationsControllerProvider);
        await locationsController.getLocations();

        EasyLoading.showSuccess('Location updated successfully');
        NavigationService.goBack();
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
        final locationsController = ref.read(locationsControllerProvider);
        await locationsController.getLocations();

        EasyLoading.showSuccess('Location deleted successfully');
        NavigationService.goBack();
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
  void dispose() {
    latitudeController.removeListener(_onLatitudeChanged);
    longitudeController.removeListener(_onLongitudeChanged);
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
}
