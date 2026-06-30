import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/core/widgets/custom_button.dart';
import 'package:field_track_todo/core/widgets/custom_button_2.dart';
import 'package:field_track_todo/features/edit_location/controller/edit_location_controller.dart';
import 'package:field_track_todo/features/edit_location/widgets/edit_latitude.dart';
import 'package:field_track_todo/features/edit_location/widgets/edit_longitude.dart';
import 'package:field_track_todo/features/edit_location/widgets/edit_location_name.dart';
import 'package:field_track_todo/features/edit_location/widgets/edit_map_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditLocationScreen extends StatelessWidget {
  const EditLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditLocationController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color backButtonBg = isDark ? AppColors.darkBorder : Colors.white;

    final Color labelColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final Color inputFillColor = isDark
        ? AppColors.darkFieldBackground
        : Colors.white;

    final Color inputBorderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    final Color sliderInactiveColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: backButtonBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Edit location',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              EditMapPreview(
                inputBorderColor: inputBorderColor,
                controller: controller,
                theme: theme,
              ),
              const SizedBox(height: 24),

              Text(
                'Location name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 8),
              EditLocationName(
                controller: controller,
                isDark: isDark,
                labelColor: labelColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                theme: theme,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  EditLatitude(
                    labelColor: labelColor,
                    controller: controller,
                    isDark: isDark,
                    inputFillColor: inputFillColor,
                    inputBorderColor: inputBorderColor,
                    theme: theme,
                  ),
                  const SizedBox(width: 16),
                  EditLongitude(
                    labelColor: labelColor,
                    controller: controller,
                    isDark: isDark,
                    inputFillColor: inputFillColor,
                    inputBorderColor: inputBorderColor,
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Geofence radius',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${controller.radius.value.toInt()} m',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: theme.primaryColor,
                    inactiveTrackColor: sliderInactiveColor,
                    thumbColor: theme.primaryColor,
                    overlayColor: theme.primaryColor.withValues(alpha: 0.1),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                  ),
                  child: Slider(
                    min: 50.0,
                    max: 1000.0,
                    value: controller.radius.value,
                    onChanged: controller.updateRadius,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Workers can check in here',
                        style: TextStyle(fontSize: 12, color: labelColor),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Obx(
                    () => Switch.adaptive(
                      value: controller.isActive.value,
                      onChanged: controller.toggleActive,
                      activeThumbColor: Colors.white,
                      activeTrackColor: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Save location',
                onPressed: controller.saveLocation,
                height: 56,
                backgroundColor: theme.primaryColor,
                textColor: isDark ? AppColors.darkBackground : Colors.white,
              ),
              const SizedBox(height: 16),

              CustomButton2(
                text: 'Delete location',
                onPressed: controller.deleteLocation,
                textColor: AppColors.red,
                borderColor: AppColors.red,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
