import 'package:dotted_border/dotted_border.dart';
import 'package:field_track_todo/features/create_location/controller/create_location_controller.dart';
import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({
    super.key,
    required this.isDark,
    required this.theme,
    required this.controller,
  });

  final bool isDark;
  final ThemeData theme;
  final CreateLocationController controller;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(16),
        color: isDark
            ? theme.primaryColor.withValues(alpha: 0.8)
            : theme.primaryColor.withValues(alpha: 0.5),
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        padding: EdgeInsets.zero,
      ),
      child: InkWell(
        onTap: controller.useCurrentLocation,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.my_location, color: theme.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Use my current location',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
