import 'package:field_track_todo/core/common/app_color.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.iconBg,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconBg;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
