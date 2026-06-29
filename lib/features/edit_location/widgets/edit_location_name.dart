import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/edit_location/controller/edit_location_controller.dart';
import 'package:flutter/material.dart';

class EditLocationName extends StatelessWidget {
  final EditLocationController controller;
  final bool isDark;
  final Color labelColor;
  final Color inputFillColor;
  final Color inputBorderColor;
  final ThemeData theme;

  const EditLocationName({
    super.key,
    required this.controller,
    required this.isDark,
    required this.labelColor,
    required this.inputFillColor,
    required this.inputBorderColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.nameController,
      style: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'e.g. Downtown Branch',
        hintStyle: TextStyle(
          color: labelColor.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: inputBorderColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: inputBorderColor, width: 1.5),
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
    );
  }
}
