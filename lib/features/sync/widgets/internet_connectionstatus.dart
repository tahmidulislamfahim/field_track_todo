import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/sync/controller/sync_controller.dart';
import 'package:flutter/material.dart';

class InternetConnectionstatus extends StatelessWidget {
  const InternetConnectionstatus({
    super.key,
    required this.controller,
    required this.warningBg,
    required this.warningFg,
  });

  final SyncController controller;
  final Color warningBg;
  final Color warningFg;

  @override
  Widget build(BuildContext context) {
    if (!controller.isOffline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warningBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.wifi_off_outlined, color: warningFg, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're offline",
                  style: TextStyle(
                    color: warningFg,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Changes are saved on this device',
                  style: TextStyle(
                    color: AppColors.lightTextSecondary,
                    fontSize: 13,
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
