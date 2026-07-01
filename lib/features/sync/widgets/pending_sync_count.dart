import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/sync/controller/sync_controller.dart';
import 'package:flutter/material.dart';

class PendingSyncCount extends StatelessWidget {
  const PendingSyncCount({
    super.key,
    required this.controller,
    required this.cardBg,
    required this.isDark,
    required this.syncIconBg,
    required this.theme,
  });

  final SyncController controller;
  final Color cardBg;
  final bool isDark;
  final Color syncIconBg;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final bool hasPending = controller.pendingChanges.isNotEmpty;
    final String statusTitle = hasPending
        ? '${controller.pendingChanges.length} changes pending'
        : 'All changes uploaded';

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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: syncIconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.sync, color: theme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last synced ${controller.lastSyncedTime}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
