import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CreateLocationController extends GetxController {
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
    latitudeController.text = latitude.value.toString();
    longitudeController.text = longitude.value.toString();
    
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

  Future<void> useCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services on your device.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are denied.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Permanently Denied',
        'Location permissions are permanently denied, we cannot request permissions.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Get current location coordinates
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      
      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();
      _moveMap();

      // Reverse geocode the coordinates to fetch the actual place/street name
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final String? street = placemark.street;
        final String? locality = placemark.locality;
        final String? subAdministrativeArea = placemark.subAdministrativeArea;
        
        String name = '';
        if (street != null && street.isNotEmpty) {
          name = street;
        } else if (locality != null && locality.isNotEmpty) {
          name = locality;
        } else if (subAdministrativeArea != null && subAdministrativeArea.isNotEmpty) {
          name = subAdministrativeArea;
        } else {
          name = 'My Location';
        }
        
        nameController.text = name;
      } else {
        nameController.text = 'My Location';
      }

      Get.snackbar(
        'Success',
        'Fetched current device location',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch device location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
      Get.snackbar('Error', 'Please enter a location name', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (lat == null) {
      Get.snackbar('Error', 'Please enter a valid latitude', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (lng == null) {
      Get.snackbar('Error', 'Please enter a valid longitude', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Create a new location object
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newLoc = LocationModel(
      id: id,
      locationName: name,
      latitude: lat,
      longitude: lng,
      radiusM: radius.value,
      isActive: isActive.value,
    );

    // Save using the LocationsController
    try {
      final locationsController = Get.find<LocationsController>();
      locationsController.addLocation(newLoc);
      
      Get.back(); // Return to previous screen
      Get.snackbar('Success', 'Location saved successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Could not save location. Make sure you opened the locations list first.', snackPosition: SnackPosition.BOTTOM);
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
