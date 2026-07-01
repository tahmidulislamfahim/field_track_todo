import 'package:collection/collection.dart';
import 'package:field_track_todo/features/sync/controller/sync_controller.dart';
import 'package:field_track_todo/features/tasks/model/task_model.dart';
import 'package:field_track_todo/features/tasks/service/task_service.dart';
import 'package:field_track_todo/core/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskFilter { all, pending, completed }

final tasksControllerProvider = ChangeNotifierProvider.autoDispose((ref) => TasksController(ref));

class TasksController extends ChangeNotifier {
  final Ref ref;

  List<Task> tasks = [];
  TaskFilter activeFilter = TaskFilter.all;
  bool isLoading = false;

  final TaskService _taskService = TaskService();

  TasksController(this.ref) {
    getTodos();
  }

  Future<void> getTodos() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _taskService.fetchTodos();
      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map && body['data'] != null) {
          final List rawData = body['data'];
          final parsed = rawData
              .map((json) => Task.fromJson(Map<String, dynamic>.from(json)))
              .toList();

          final syncController = ref.read(syncControllerProvider);
          for (var task in parsed) {
            final pending = syncController.pendingChanges.firstWhereOrNull(
              (p) => p.todoId == task.id,
            );
            if (pending != null) {
              task.isCompleted = pending.isCompleted;
              task.updatedAt = pending.updatedAt;
            }
          }

          tasks = parsed;
        }
      } else {
        EasyLoading.showError('Failed to load tasks.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred loading tasks.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final nextStatus = !task.isCompleted;
    final now = DateTime.now();
    final syncController = ref.read(syncControllerProvider);

    if (syncController.isOffline) {
      task.isCompleted = nextStatus;
      task.updatedAt = now;
      notifyListeners();

      syncController.addPendingChange(
        todoId: task.id,
        title: task.title,
        isCompleted: nextStatus,
        updatedAt: now,
      );

      EasyLoading.showSuccess(
        nextStatus ? 'Task completed offline' : 'Task reopened offline',
      );
      return;
    }

    EasyLoading.show(
      status: nextStatus ? 'Completing task...' : 'Reopening task...',
    );

    try {
      final response = await _taskService.updateTodo(
        todoId: task.id,
        isCompleted: nextStatus,
        updatedAt: now,
      );

      if (response.status.isOk) {
        task.isCompleted = nextStatus;
        task.updatedAt = now;
        notifyListeners();
        EasyLoading.showSuccess(
          nextStatus ? 'Task completed' : 'Task reopened',
        );
      } else if (response.status.connectionError || response.statusCode == null) {
        _saveOfflineFallback(task, nextStatus, now);
      } else {
        final errorMsg = _getErrorMessage(response);
        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      _saveOfflineFallback(task, nextStatus, now);
    }
  }

  String _getErrorMessage(Response response) {
    final body = response.body;
    if (body != null && body is Map) {
      final error = body['error'];
      if (error != null && error is Map && error['message'] != null) {
        return error['message'].toString();
      }
      if (body['message'] != null) {
        return body['message'].toString();
      }
    }
    return 'Failed to update task (${response.statusCode})';
  }

  void _saveOfflineFallback(Task task, bool nextStatus, DateTime now) {
    task.isCompleted = nextStatus;
    task.updatedAt = now;
    notifyListeners();

    final syncController = ref.read(syncControllerProvider);
    syncController.addPendingChange(
      todoId: task.id,
      title: task.title,
      isCompleted: nextStatus,
      updatedAt: now,
    );

    syncController.isOffline = true;

    EasyLoading.showSuccess(
      nextStatus ? 'Task completed offline' : 'Task reopened offline',
    );
  }

  void changeFilter(TaskFilter filter) {
    activeFilter = filter;
    notifyListeners();
  }

  bool _isToday(DateTime dateTime) {
    final utcDate = dateTime.toUtc();
    final nowUtc = DateTime.now().toUtc();
    return utcDate.year == nowUtc.year &&
        utcDate.month == nowUtc.month &&
        utcDate.day == nowUtc.day;
  }

  int get totalCount => tasks.length;

  int get completedCount => tasks
      .where((task) => task.isCompleted && _isToday(task.updatedAt))
      .length;

  double get progressPercent {
    if (totalCount == 0) return 0.0;
    return completedCount / totalCount;
  }

  String get progressText => '$completedCount of $totalCount done';

  List<Task> get filteredTasks {
    switch (activeFilter) {
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return tasks.toList();
    }
  }
}
