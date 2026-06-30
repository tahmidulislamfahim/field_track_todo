import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/location/model/location_model.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback? onTap;

  const LocationCard({super.key, required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg = location.isActive
        ? (isDark ? AppColors.darkFieldBackground : Colors.white)
        : (isDark
              ? AppColors.darkInactiveLocationCardBg
              : AppColors.lightInactiveLocationCardBg);

    final Color leadingBg = location.isActive
        ? (isDark
              ? AppColors.darkLocationActiveBg
              : AppColors.lightLocationActiveBg)
        : (isDark
              ? AppColors.darkLocationInactiveBg
              : AppColors.lightLocationInactiveBg);

    final Color leadingIconColor = location.isActive
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : (isDark
              ? AppColors.darkStatusInactiveText
              : AppColors.lightStatusInactiveText);

    final Color radiusBg = isDark
        ? AppColors.darkLocationInactiveBg
        : AppColors.lightLocationInactiveBg;

    final Color radiusTextColor = isDark
        ? AppColors.darkStatusInactiveText
        : AppColors.lightStatusInactiveText;

    final Color statusBg = location.isActive
        ? (isDark
              ? AppColors.darkLocationActiveBg
              : AppColors.lightLocationActiveBg)
        : (isDark
              ? AppColors.darkLocationInactiveBg
              : AppColors.lightLocationInactiveBg);

    final Color statusTextColor = location.isActive
        ? (isDark
              ? AppColors.darkStatusActiveText
              : AppColors.lightStatusActiveText)
        : (isDark
              ? AppColors.darkStatusInactiveText
              : AppColors.lightStatusInactiveText);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: leadingBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on_outlined,
                      color: leadingIconColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.gps_fixed,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: radiusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${location.radius.toInt()} m radius',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: radiusTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              location.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: statusTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
                      : AppColors.lightTextSecondary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
