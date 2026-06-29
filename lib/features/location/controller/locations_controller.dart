import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:get/get.dart';

class LocationsController extends GetxController {
  final locations = <LocationModel>[].obs;
  final filteredLocations = <LocationModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMockLocations();
  }

  void _initializeMockLocations() {
    final mockList = [
      LocationModel(
        id: '1',
        name: 'Downtown Branch',
        latitude: 25.2048,
        longitude: 55.2708,
        radius: 150.0,
        isActive: true,
      ),
      LocationModel(
        id: '2',
        name: 'Warehouse',
        latitude: 25.2101,
        longitude: 55.2801,
        radius: 200.0,
        isActive: true,
      ),
      LocationModel(
        id: '3',
        name: 'North Depot',
        latitude: 25.1980,
        longitude: 55.2650,
        radius: 120.0,
        isActive: false,
      ),
    ];
    locations.assignAll(mockList);
    filteredLocations.assignAll(mockList);
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLocations.assignAll(locations);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredLocations.assignAll(
        locations.where((loc) {
          final matchesName = loc.name.toLowerCase().contains(lowercaseQuery);
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
  }

  void toggleLocationStatus(String id) {
    final index = locations.indexWhere((loc) => loc.id == id);
    if (index != -1) {
      final updated = locations[index].copyWith(isActive: !locations[index].isActive);
      locations[index] = updated;
      search(searchQuery.value);
    }
  }
}
