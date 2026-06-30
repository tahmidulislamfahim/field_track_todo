import 'package:field_track_todo/core/services/geofence_service.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:field_track_todo/features/location/service/location_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LocationsController extends GetxController {
  final locations = <LocationModel>[].obs;
  final filteredLocations = <LocationModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final LocationService _locationService = Get.put(LocationService());

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  Future<void> getLocations() async {
    isLoading.value = true;
    try {
      final response = await _locationService.fetchLocations();
      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map && body['data'] != null) {
          final List rawData = body['data'];
          final parsed = rawData.map((json) => LocationModel.fromJson(json)).toList();
          locations.assignAll(parsed);
          search(searchQuery.value);
          GeofenceService().startMonitoring();
        }
      } else {
        EasyLoading.showError('Failed to load locations.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred loading locations.');
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLocations.assignAll(locations);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredLocations.assignAll(
        locations.where((loc) {
          final matchesName = loc.locationName.toLowerCase().contains(lowercaseQuery);
          final matchesLat = loc.latitude.toString().contains(lowercaseQuery);
          final matchesLng = loc.longitude.toString().contains(lowercaseQuery);
          return matchesName || matchesLat || matchesLng;
        }).toList(),
      );
    }
  }

  void addLocation(LocationModel location) {
    locations.add(location);
    search(searchQuery.value);
    GeofenceService().startMonitoring();
  }

  void toggleLocationStatus(String id) {
    final index = locations.indexWhere((loc) => loc.id == id);
    if (index != -1) {
      final updated = locations[index].copyWith(isActive: !locations[index].isActive);
      locations[index] = updated;
      search(searchQuery.value);
      GeofenceService().startMonitoring();
    }
  }

  void updateLocation(LocationModel updated) {
    final index = locations.indexWhere((loc) => loc.id == updated.id);
    if (index != -1) {
      locations[index] = updated;
      search(searchQuery.value);
      GeofenceService().startMonitoring();
    }
  }

  void deleteLocation(String id) {
    locations.removeWhere((loc) => loc.id == id);
    search(searchQuery.value);
    GeofenceService().startMonitoring();
  }
}
