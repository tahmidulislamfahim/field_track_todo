import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/edit_location/controller/edit_location_controller.dart';
import 'package:flutter/material.dart';

class EditLongitude extends StatelessWidget {
  final Color labelColor;
  final EditLocationController controller;
  final bool isDark;
  final Color inputFillColor;
  final Color inputBorderColor;
  final ThemeData theme;

  const EditLongitude({
    super.key,
    required this.labelColor,
    required this.controller,
    required this.isDark,
    required this.inputFillColor,
    required this.inputBorderColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Longitude',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.longitudeController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: inputFillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: inputBorderColor,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: inputBorderColor,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
