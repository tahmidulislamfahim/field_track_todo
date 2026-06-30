import 'package:field_track_todo/features/sync/model/sync_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncController extends GetxController {
  final isOffline = true.obs;
  final lastSyncedTime = 'today, 9:45 AM'.obs;
  final isLoading = false.obs;

  final pendingChanges = <SyncItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockPendingChanges();
  }

  void _loadMockPendingChanges() {
    pendingChanges.assignAll([
      const SyncItem(
        title: 'Take inventory count',
        time: '10:15 AM',
        icon: Icons.inventory_2_outlined,
        type: 'inventory',
      ),
      const SyncItem(
        title: 'Visit branch manager',
        time: '10:18 AM',
        icon: Icons.description_outlined,
        type: 'document',
      ),
      const SyncItem(
        title: 'Update store display',
        time: '10:24 AM',
        icon: Icons.location_on_outlined,
        type: 'location',
      ),
    ]);
  }

  Future<void> syncNow() async {
    if (pendingChanges.isEmpty) return;

    isLoading.value = true;

    try {
      // Simulate network syncing request
      await Future.delayed(const Duration(milliseconds: 2000));

      pendingChanges.clear();
      isOffline.value = false;
      lastSyncedTime.value = 'today, 3:32 PM'; // Simulated new sync timestamp

      Get.snackbar(
        'Sync Complete',
        'All changes have been successfully uploaded.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    } catch (e) {
      Get.snackbar(
        'Sync Failed',
        'Unable to upload changes. Please check connection.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
