import 'package:field_track_todo/core/services/geofence_service.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:field_track_todo/features/location/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationsControllerProvider = ChangeNotifierProvider.autoDispose((ref) => LocationsController());

class LocationsController extends ChangeNotifier {
  List<LocationModel> locations = [];
  List<LocationModel> filteredLocations = [];
  String searchQuery = '';
  bool isLoading = false;

  final LocationService _locationService = LocationService();

  LocationsController() {
    getLocations();
  }

  Future<void> getLocations() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _locationService.fetchLocations();
      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map && body['data'] != null) {
          final List rawData = body['data'];
          final parsed = rawData.map((json) => LocationModel.fromJson(json)).toList();
          locations = parsed;
          search(searchQuery);
          GeofenceService().startMonitoring();
        }
      } else {
        EasyLoading.showError('Failed to load locations.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred loading locations.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      filteredLocations = List.from(locations);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredLocations = locations.where((loc) {
        final matchesName = loc.locationName.toLowerCase().contains(lowercaseQuery);
        final matchesLat = loc.latitude.toString().contains(lowercaseQuery);
        final matchesLng = loc.longitude.toString().contains(lowercaseQuery);
        return matchesName || matchesLat || matchesLng;
      }).toList();
    }
    notifyListeners();
  }

  void addLocation(LocationModel location) {
    locations.add(location);
    search(searchQuery);
    GeofenceService().startMonitoring();
  }

  void toggleLocationStatus(String id) {
    final index = locations.indexWhere((loc) => loc.id == id);
    if (index != -1) {
      final updated = locations[index].copyWith(isActive: !locations[index].isActive);
      locations[index] = updated;
      search(searchQuery);
      GeofenceService().startMonitoring();
    }
  }

  void updateLocation(LocationModel updated) {
    final index = locations.indexWhere((loc) => loc.id == updated.id);
    if (index != -1) {
      locations[index] = updated;
      search(searchQuery);
      GeofenceService().startMonitoring();
    }
  }

  void deleteLocation(String id) {
    locations.removeWhere((loc) => loc.id == id);
    search(searchQuery);
    GeofenceService().startMonitoring();
  }
}
