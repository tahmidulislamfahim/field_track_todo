import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/tasks/model/task_model.dart';
import 'package:field_track_todo/features/tasks/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTapCheckbox;

  const TaskCard({super.key, required this.task, required this.onTapCheckbox});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg = isDark ? AppColors.darkFieldBackground : Colors.white;

    return Obx(() {
      final bool completed = task.isCompleted.value;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTapCheckbox,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 4.0),
                child: completed
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.successGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkCheckboxBorder
                                : AppColors.lightCheckboxBorder,
                            width: 2,
                          ),
                        ),
                      ),
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: completed
                          ? (isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400)
                          : (isDark ? Colors.white : AppColors.lightLogoText),
                      decoration: completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            completed
                                ? 'Done ${task.time}'
                                : 'Due ${task.time}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),

                      StatusBadge(completed: completed, isDark: isDark, primaryColor: theme.primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
