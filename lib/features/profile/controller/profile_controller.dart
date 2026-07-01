import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/tasks/controller/tasks_controller.dart';
import 'package:field_track_todo/features/profile/service/profile_service.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:field_track_todo/core/services/navigation_service.dart';
import 'package:field_track_todo/core/services/geofence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  final controller = ProfileController(ref);
  ref.listen(locationsControllerProvider, (previous, next) {
    controller.updateStats();
  });
  ref.listen(tasksControllerProvider, (previous, next) {
    controller.updateStats();
  });
  return controller;
});

class ProfileController extends ChangeNotifier {
  final Ref ref;

  String name = '';
  String email = '';
  String initials = '';
  String role = '';

  String tasksDoneToday = '0/0';
  int activeLocationsCount = 0;

  final ProfileService _profileService = ProfileService();

  ProfileController(this.ref) {
    getProfileInfo();
    updateStats();
  }

  Future<void> getProfileInfo() async {
    try {
      final response = await _profileService.fetchProfile();
      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map) {
          name = body['name'] ?? 'User';
          email = body['email'] ?? '';
          role = _formatRole(body['role'] ?? '');
          _updateInitials(name);
          notifyListeners();
        }
      } else {
        EasyLoading.showError('Failed to fetch profile details.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred loading profile info.');
    }
  }

  void updateStats() {
    try {
      final tasksController = ref.read(tasksControllerProvider);
      tasksDoneToday =
          '${tasksController.completedCount}/${tasksController.totalCount}';
    } catch (_) {
      tasksDoneToday = '0/0';
    }

    try {
      final locationsController = ref.read(locationsControllerProvider);
      activeLocationsCount = locationsController.locations
          .where((loc) => loc.isActive)
          .length;
    } catch (_) {
      activeLocationsCount = 0;
    }
    notifyListeners();
  }

  void _updateInitials(String fullName) {
    final cleanName = fullName.trim();
    if (cleanName.isEmpty) {
      initials = 'U';
      return;
    }
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      initials = parts[0][0].toUpperCase();
    } else {
      initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
  }

  String _formatRole(String rawRole) {
    if (rawRole.isEmpty) return '';
    final withSpaces = rawRole.replaceAll('_', ' ');
    final words = withSpaces.split(' ');
    final capitalized = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    });
    return capitalized.join(' ');
  }

  Future<void> signOut() async {
    EasyLoading.show(status: 'Signing out...');
    try {
      final response = await _profileService.logoutUser();
      if (response.status.isOk) {
        await GeofenceService().stopMonitoring();
        await SharedPreferencesHelper.clearAll();

        NavigationService.clearStackAndShow(AppRoutes.login);
        EasyLoading.showSuccess('Signed out successfully!');
      } else {
        EasyLoading.showError('Logout failed from server.');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      EasyLoading.showError('An unexpected error occurred.');
    }
  }
}
