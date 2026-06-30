import 'package:field_track_todo/features/tasks/model/task_model.dart';
import 'package:field_track_todo/features/tasks/service/task_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

enum TaskFilter { all, pending, completed }

class TasksController extends GetxController {
  final tasks = <Task>[].obs;
  final activeFilter = TaskFilter.all.obs;
  final isLoading = false.obs;

  final TaskService _taskService = Get.put(TaskService());

  @override
  void onInit() {
    super.onInit();
    getTodos();
  }

  Future<void> getTodos() async {
    isLoading.value = true;
    try {
      final response = await _taskService.fetchTodos();
      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map && body['data'] != null) {
          final List rawData = body['data'];
          final parsed = rawData.map((json) => Task.fromJson(Map<String, dynamic>.from(json))).toList();
          tasks.assignAll(parsed);
        }
      } else {
        EasyLoading.showError('Failed to load tasks.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred loading tasks.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final nextStatus = !task.isCompleted.value;
    final now = DateTime.now();

    EasyLoading.show(status: nextStatus ? 'Completing task...' : 'Reopening task...');

    try {
      final response = await _taskService.updateTodo(
        todoId: task.id,
        isCompleted: nextStatus,
        updatedAt: now,
      );

      if (response.status.isOk) {
        task.isCompleted.value = nextStatus;
        task.updatedAt = now;
        tasks.refresh();
        EasyLoading.showSuccess(nextStatus ? 'Task completed' : 'Task reopened');
      } else {
        EasyLoading.showError('Failed to update task.');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred.');
    }
  }

  void changeFilter(TaskFilter filter) {
    activeFilter.value = filter;
  }

  bool _isToday(DateTime dateTime) {
    final utcDate = dateTime.toUtc();
    final nowUtc = DateTime.now().toUtc();
    return utcDate.year == nowUtc.year &&
           utcDate.month == nowUtc.month &&
           utcDate.day == nowUtc.day;
  }

  int get totalCount => tasks.length;

  int get completedCount => tasks.where((task) => task.isCompleted.value && _isToday(task.updatedAt)).length;

  double get progressPercent {
    if (totalCount == 0) return 0.0;
    return completedCount / totalCount;
  }

  String get progressText => '$completedCount of $totalCount done';

  List<Task> get filteredTasks {
    switch (activeFilter.value) {
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted.value).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted.value).toList();
      case TaskFilter.all:
        return tasks.toList();
    }
  }
}
