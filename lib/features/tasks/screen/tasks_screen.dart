import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/tasks/controller/tasks_controller.dart';
import 'package:field_track_todo/features/tasks/widgets/task_card.dart';
import 'package:field_track_todo/features/tasks/widgets/task_filter.dart';
import 'package:field_track_todo/features/tasks/widgets/task_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(tasksControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg = isDark ? AppColors.darkFieldBackground : Colors.white;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
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

              TaskProgressCard(
                cardBg: cardBg,
                isDark: isDark,
                controller: controller,
                theme: theme,
              ),
              const SizedBox(height: 24),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    TaskFilterChip(
                      label: 'All',
                      filter: TaskFilter.all,
                      activeFilter: controller.activeFilter,
                      onTap: () => controller.changeFilter(TaskFilter.all),
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    TaskFilterChip(
                      label: 'Pending',
                      filter: TaskFilter.pending,
                      activeFilter: controller.activeFilter,
                      onTap: () => controller.changeFilter(TaskFilter.pending),
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    TaskFilterChip(
                      label: 'Completed',
                      filter: TaskFilter.completed,
                      activeFilter: controller.activeFilter,
                      onTap: () => controller.changeFilter(TaskFilter.completed),
                      theme: theme,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (controller.filteredTasks.isEmpty)
                Padding(
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
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.filteredTasks[index];
                    return TaskCard(
                      task: task,
                      onTapCheckbox: () => controller.toggleTaskCompletion(task),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
