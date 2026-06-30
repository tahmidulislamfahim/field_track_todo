import 'package:field_track_todo/features/tasks/model/task_model.dart';
import 'package:get/get.dart';

enum TaskFilter { all, pending, completed }

class TasksController extends GetxController {
  final tasks = <Task>[].obs;
  final activeFilter = TaskFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockTasks();
  }

  void _loadMockTasks() {
    tasks.assignAll([
      Task(
        id: '1',
        title: 'Take inventory count',
        description: 'Count shelf stock and storage stock',
        time: '9:30 AM',
        isCompleted: true,
      ),
      Task(
        id: '2',
        title: 'Visit branch manager',
        description: 'Collect signed documents',
        time: '10:00 AM',
        isCompleted: false,
      ),
      Task(
        id: '3',
        title: 'Verify delivery shipment',
        description: 'Check items against the manifest',
        time: '11:30 AM',
        isCompleted: false,
      ),
      Task(
        id: '4',
        title: 'Update store display',
        description: 'Arrange promotional materials',
        time: '2:00 PM',
        isCompleted: false,
      ),
      Task(
        id: '5',
        title: 'Submit daily report',
        description: 'Log visit summary and photos',
        time: '5:00 PM',
        isCompleted: false,
      ),
    ]);
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted.value = !task.isCompleted.value;
  }

  void changeFilter(TaskFilter filter) {
    activeFilter.value = filter;
  }

  int get totalCount => tasks.length;

  int get completedCount => tasks.where((task) => task.isCompleted.value).length;

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
