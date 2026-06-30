import 'package:get/get.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final RxBool isCompleted;
  final DateTime dueAt;
  final DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required bool isCompleted,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isCompleted = isCompleted.obs;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      dueAt: json['due_at'] != null ? DateTime.parse(json['due_at']) : DateTime.now(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted.value,
      'due_at': dueAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
