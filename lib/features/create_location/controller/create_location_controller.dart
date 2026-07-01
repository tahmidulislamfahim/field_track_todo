import 'package:field_track_todo/features/create_location/service/create_location_service.dart';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

final createLocationControllerProvider = ChangeNotifierProvider.autoDispose((ref) => CreateLocationController(ref));

class CreateLocationController extends ChangeNotifier {
  final Ref ref;

  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  double radius = 150.0;
  bool isActive = true;
  double latitude = 0.0;
  double longitude = 0.0;

  final MapController mapController = MapController();
  final CreateLocationService _createLocationService = CreateLocationService();

  CreateLocationController(this.ref) {
    latitudeController.text = latitude == 0.0 ? '' : latitude.toString();
    longitudeController.text = longitude == 0.0 ? '' : longitude.toString();

    latitudeController.addListener(_onLatitudeChanged);
    longitudeController.addListener(_onLongitudeChanged);

    useCurrentLocation();
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

  Future<void> useCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showError('Location Services Disabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showError('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      EasyLoading.showError('Location permissions are permanently denied.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude = position.latitude;
      longitude = position.longitude;

      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();
      _moveMap();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
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
        } else if (subAdministrativeArea != null &&
            subAdministrativeArea.isNotEmpty) {
          name = subAdministrativeArea;
        } else {
          name = 'My Location';
        }

        nameController.text = name;
      } else {
        nameController.text = 'My Location';
      }

      EasyLoading.showSuccess('Fetched current device location');
      notifyListeners();
    } catch (e) {
      EasyLoading.showError('Failed to fetch device location');
    }
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

    EasyLoading.show(status: 'Saving location...');

    try {
      final response = await _createLocationService.createLocation(
        name: name,
        latitude: lat,
        longitude: lng,
        radiusM: radius,
      );

      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map) {
          final locationsController = ref.read(locationsControllerProvider);
          await locationsController.getLocations();

          EasyLoading.showSuccess('Location saved successfully');
          NavigationService.goBack();
        } else {
          EasyLoading.showError('Invalid server response format.');
        }
      } else {
        String errorMsg = 'Could not save location. Please try again.';
        if (response.body != null && response.body is Map) {
          errorMsg = response.body['message'] ?? errorMsg;
        }
        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      EasyLoading.showError('An unexpected error occurred.');
    }
  }
}
