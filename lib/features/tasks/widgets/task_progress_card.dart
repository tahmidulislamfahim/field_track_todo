import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/tasks/controller/tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskProgressCard extends StatelessWidget {
  const TaskProgressCard({
    super.key,
    required this.cardBg,
    required this.isDark,
    required this.controller,
    required this.theme,
  });

  final Color cardBg;
  final bool isDark;
  final TasksController controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's progress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Text(
                  controller.progressText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
    
          Obx(() {
            final double percent = controller.progressPercent;
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 8,
                backgroundColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.primaryColor,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
