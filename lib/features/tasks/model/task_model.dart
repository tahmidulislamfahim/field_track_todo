import 'package:get/get.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String time; // e.g. "9:30 AM", "10:00 AM"
  final RxBool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required bool isCompleted,
  }) : isCompleted = isCompleted.obs;
}
