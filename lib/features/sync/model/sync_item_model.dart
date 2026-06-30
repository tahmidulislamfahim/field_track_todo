class SyncItem {
  final String todoId;
  final String title;
  final bool isCompleted;
  final DateTime updatedAt;

  const SyncItem({
    required this.todoId,
    required this.title,
    required this.isCompleted,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'todo_id': todoId,
      'title': title,
      'is_completed': isCompleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SyncItem.fromJson(Map<String, dynamic> json) {
    return SyncItem(
      todoId: json['todo_id'] ?? '',
      title: json['title'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

