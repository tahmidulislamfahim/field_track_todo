import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/tasks/controller/tasks_controller.dart';
import 'package:flutter/material.dart';

class TaskFilterChip extends StatelessWidget {
  const TaskFilterChip({
    super.key,
    required this.label,
    required this.filter,
    required this.activeFilter,
    required this.onTap,
    required this.theme,
    required this.isDark,
  });

  final String label;
  final TaskFilter filter;
  final TaskFilter activeFilter;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = activeFilter == filter;

    final Color bg = isSelected
        ? theme.primaryColor
        : Colors.transparent;

    final Color fg = isSelected
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    final Border border = isSelected
        ? Border.all(color: Colors.transparent, width: 1.5)
        : Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.5,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
          border: border,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
