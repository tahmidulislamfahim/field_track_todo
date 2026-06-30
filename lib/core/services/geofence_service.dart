import 'dart:async';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:field_track_todo/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GeofenceService {
  static final GeofenceService _instance = GeofenceService._internal();
  factory GeofenceService() => _instance;
  GeofenceService._internal();

  StreamSubscription<Position>? _positionStreamSubscription;
  final Set<String> _enteredLocationIds = {};

  Future<void> startMonitoring() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('GeofenceService: Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('GeofenceService: Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('GeofenceService: Location permissions are permanently denied.');
      return;
    }

    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    await NotificationService().requestPermissions();

    await stopMonitoring();

    final LocationSettings locationSettings = defaultTargetPlatform == TargetPlatform.android
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
            intervalDuration: const Duration(seconds: 5),
            foregroundNotificationConfig: ForegroundNotificationConfig(
              notificationTitle: 'FieldTrack Monitoring Active',
              notificationText: 'Monitoring geofences for location-based alerts.',
              enableWakeLock: true,
            ),
          )
        : defaultTargetPlatform == TargetPlatform.iOS
            ? AppleSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 5,
                activityType: ActivityType.fitness,
                showBackgroundLocationIndicator: true,
              )
            : const LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 5,
              );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _checkGeofences(position);
    }, onError: (error) {
      debugPrint('GeofenceService position stream error: $error');
    });

    debugPrint('GeofenceService started location monitoring.');
  }

  Future<void> stopMonitoring() async {
    if (_positionStreamSubscription != null) {
      await _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }
  }

  void _checkGeofences(Position position) {
    try {
      final locationsController = Get.find<LocationsController>();
      final activeLocations = locationsController.locations.where((loc) => loc.isActive).toList();

      for (final LocationModel loc in activeLocations) {
        final double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          loc.latitude,
          loc.longitude,
        );

        final bool isInside = distance <= loc.radius;
        final String locId = loc.id;

        if (isInside) {
          if (!_enteredLocationIds.contains(locId)) {
            _enteredLocationIds.add(locId);
            debugPrint('GeofenceService: Entered boundary of ${loc.name}');

            NotificationService().showNotification(
              id: locId.hashCode,
              title: 'Location Alert',
              body: 'You entered ${loc.name}',
            );
          }
        } else {
          if (_enteredLocationIds.contains(locId)) {
            _enteredLocationIds.remove(locId);
            debugPrint('GeofenceService: Exited boundary of ${loc.name}');
          }
        }
      }
    } catch (e) {
      debugPrint('GeofenceService error checking boundaries: $e');
    }
  }
}
