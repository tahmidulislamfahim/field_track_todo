import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:flutter/material.dart';

class SearchLocation extends StatelessWidget {
  const SearchLocation({
    super.key,
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final LocationsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
      child: TextField(
        onChanged: controller.search,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search locations',
          prefixIcon: Icon(
            Icons.search,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkFieldBackground : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
