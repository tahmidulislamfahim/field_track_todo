import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:collection/collection.dart';
import 'package:field_track_todo/features/sync/model/sync_item_model.dart';
import 'package:field_track_todo/features/sync/service/sync_service.dart';
import 'package:field_track_todo/features/tasks/controller/tasks_controller.dart';
import 'package:field_track_todo/core/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final syncControllerProvider = ChangeNotifierProvider.autoDispose((ref) => SyncController(ref));

class SyncController extends ChangeNotifier {
  final Ref ref;

  bool isOffline = false;
  String lastSyncedTime = 'never';
  bool isLoading = false;
  List<SyncItem> pendingChanges = [];

  bool _isSyncing = false;

  final SyncService _syncService = SyncService();
  static const String _storageKey = 'pending_todo_sync_changes';
  static const String _lastSyncTimeKey = 'last_todo_sync_time';

  SyncController(this.ref) {
    _loadPendingChanges();
    _initConnectivityListener();
  }

  Future<void> _loadPendingChanges() async {
    final prefs = await SharedPreferences.getInstance();
    lastSyncedTime = prefs.getString(_lastSyncTimeKey) ?? 'never';

    final savedData = prefs.getString(_storageKey);
    if (savedData != null) {
      try {
        final List decoded = jsonDecode(savedData);
        final list = decoded.map((item) => SyncItem.fromJson(item)).toList();
        pendingChanges = list;
      } catch (e) {
        debugPrint('Error loading pending changes: $e');
      }
    }
    notifyListeners();
  }

  Future<void> _savePendingChangesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = pendingChanges.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> _saveLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final formattedTime = _formatTime(now);
    lastSyncedTime = formattedTime;
    notifyListeners();
    await prefs.setString(_lastSyncTimeKey, formattedTime);
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return 'today, $hour:$minute $period';
  }

  void _initConnectivityListener() {
    Connectivity().checkConnectivity().then((List<ConnectivityResult> results) {
      _updateConnectivityStatus(results);
    });

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectivityStatus(results);
    });
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final hasConn = results.any((r) => r != ConnectivityResult.none);
    final previouslyOffline = isOffline;
    isOffline = !hasConn;
    notifyListeners();

    if (previouslyOffline && !isOffline && pendingChanges.isNotEmpty) {
      debugPrint('Internet connection restored. Triggering auto-sync...');
      syncNow();
    }
  }

  void addPendingChange({
    required String todoId,
    required String title,
    required bool isCompleted,
    required DateTime updatedAt,
  }) {
    final existingIndex = pendingChanges.indexWhere(
      (item) => item.todoId == todoId,
    );
    final newItem = SyncItem(
      todoId: todoId,
      title: title,
      isCompleted: isCompleted,
      updatedAt: updatedAt,
    );

    if (existingIndex >= 0) {
      pendingChanges[existingIndex] = newItem;
    } else {
      pendingChanges.add(newItem);
    }
    notifyListeners();
    _savePendingChangesToStorage();
  }

  Map<String, dynamic> _parseResponseBody(Response response) {
    final body = response.body;
    if (body == null) {
      return {};
    }
    if (body is Map) {
      return Map<String, dynamic>.from(body);
    }
    if (body is String) {
      try {
        return Map<String, dynamic>.from(jsonDecode(body));
      } catch (e) {
        debugPrint('Error parsing body String: $e');
      }
    }
    final bodyStr = response.bodyString;
    if (bodyStr != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(bodyStr));
      } catch (e) {
        debugPrint('Error parsing bodyString: $e');
      }
    }
    return {};
  }

  Future<void> syncNow() async {
    if (pendingChanges.isEmpty) return;
    if (isOffline) {
      EasyLoading.showError('Cannot sync changes while offline.');
      return;
    }
    if (_isSyncing) {
      debugPrint('Sync already in progress. Skipping...');
      return;
    }

    _isSyncing = true;
    isLoading = true;
    notifyListeners();

    try {
      final changesPayload = pendingChanges
          .map(
            (item) => {
              'todo_id': item.todoId,
              'is_completed': item.isCompleted,
              'updated_at': item.updatedAt.toUtc().toIso8601String(),
            },
          )
          .toList();

      final response = await _syncService.syncTodos(changesPayload);

      if (response.status.isOk) {
        final bodyMap = _parseResponseBody(response);
        final List syncedIds = bodyMap['synced_ids'] ?? [];
        final List failedList = bodyMap['failed'] ?? [];

        final int actualSyncedCount = pendingChanges
            .where((item) => syncedIds.contains(item.todoId))
            .length;

        pendingChanges.removeWhere((item) => syncedIds.contains(item.todoId));

        final List<String> errorMessages = [];
        for (var failedItem in failedList) {
          if (failedItem is Map) {
            final String failedTodoId = failedItem['todo_id'] ?? '';
            final String reason = failedItem['reason'] ?? 'UNKNOWN_ERROR';

            final pendingItem = pendingChanges.firstWhereOrNull(
              (item) => item.todoId == failedTodoId,
            );
            if (pendingItem != null) {
              errorMessages.add('"${pendingItem.title}" ($reason)');
            }

            pendingChanges.removeWhere((item) => item.todoId == failedTodoId);
          }
        }

        await _savePendingChangesToStorage();
        await _saveLastSyncTime();

        ref.read(tasksControllerProvider).getTodos();

        if (errorMessages.isNotEmpty) {
          final String errorText =
              'Sync failed for:\n${errorMessages.join('\n')}';
          if (actualSyncedCount > 0) {
            EasyLoading.showInfo(
              'Synced $actualSyncedCount changes.\n\n$errorText',
              duration: const Duration(seconds: 5),
            );
          } else {
            EasyLoading.showError(
              errorText,
              duration: const Duration(seconds: 5),
            );
          }
        } else if (actualSyncedCount > 0) {
          EasyLoading.showSuccess(
            'Successfully synced $actualSyncedCount changes.',
          );
        }
      } else {
        throw Exception(
          'Sync request returned status code ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Sync failed: $e');
      EasyLoading.showError(
        'Unable to upload changes. Please check connection.',
      );
    } finally {
      _isSyncing = false;
      isLoading = false;
      notifyListeners();
    }
  }
}
