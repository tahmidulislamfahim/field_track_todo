import 'package:field_track_todo/features/sync/controller/sync_controller.dart';
import 'package:flutter/material.dart';

class SyncNowButton extends StatelessWidget {
  const SyncNowButton({
    super.key,
    required this.controller,
    required this.theme,
    required this.isDark,
  });

  final SyncController controller;
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bool hasPending = controller.pendingChanges.isNotEmpty;
    final bool loading = controller.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (loading || !hasPending) ? null : controller.syncNow,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: isDark ? Colors.black : Colors.white,
          disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.black : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sync,
                    color: isDark ? Colors.black : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text('Sync now'),
                ],
              ),
      ),
    );
  }
}
