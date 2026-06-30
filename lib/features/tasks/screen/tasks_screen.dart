import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/tasks/controller/tasks_controller.dart';
import 'package:field_track_todo/features/tasks/widgets/task_card.dart';
import 'package:field_track_todo/features/tasks/widgets/task_filter.dart';
import 'package:field_track_todo/features/tasks/widgets/task_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TasksController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg = isDark ? AppColors.darkFieldBackground : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My tasks',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monday, Jun 15',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              TaskProgressCard(cardBg: cardBg, isDark: isDark, controller: controller, theme: theme),
              const SizedBox(height: 24),

              Obx(() {
                final active = controller.activeFilter.value;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      TaskFilterChip(label: 'All', filter: TaskFilter.all, activeFilter: active, onTap: () => controller.changeFilter(TaskFilter.all), theme: theme, isDark: isDark),
                      const SizedBox(width: 10),
                      TaskFilterChip(label: 'Pending', filter: TaskFilter.pending, activeFilter: active, onTap: () => controller.changeFilter(TaskFilter.pending), theme: theme, isDark: isDark),
                      const SizedBox(width: 10),
                      TaskFilterChip(label: 'Completed', filter: TaskFilter.completed, activeFilter: active, onTap: () => controller.changeFilter(TaskFilter.completed), theme: theme, isDark: isDark),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              Obx(() {
                final filtered = controller.filteredTasks;
                if (filtered.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final task = filtered[index];
                    return TaskCard(
                      task: task,
                      onTapCheckbox: () => controller.toggleTaskCompletion(task),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
