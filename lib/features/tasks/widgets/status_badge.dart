import 'package:field_track_todo/core/common/app_color.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.completed,
    required this.isDark,
    required this.primaryColor,
  });

  final bool completed;
  final bool isDark;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final String text = completed ? 'Completed' : 'Pending';

    final Color bg = completed
        ? (isDark ? AppColors.darkSuccessBg : AppColors.lightSuccessBg)
        : (isDark ? AppColors.darkWarningBg : AppColors.lightWarningBg);

    final Color fg = completed
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : (isDark ? AppColors.darkWarningText : AppColors.lightWarningText);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
