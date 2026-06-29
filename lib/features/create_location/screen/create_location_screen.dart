import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/core/widgets/custom_button.dart';
import 'package:field_track_todo/features/create_location/controller/create_location_controller.dart';
import 'package:field_track_todo/features/create_location/widgets/current_location_button.dart';
import 'package:field_track_todo/features/create_location/widgets/lang_section.dart';
import 'package:field_track_todo/features/create_location/widgets/lat_section.dart';
import 'package:field_track_todo/features/create_location/widgets/location_name.dart';
import 'package:field_track_todo/features/create_location/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateLocationScreen extends StatelessWidget {
  const CreateLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateLocationController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color backButtonBg = isDark
        ? AppColors.darkBorder
        : AppColors.lightLocationInactiveBg;

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
                    'New location',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              MapPreview(
                inputBorderColor: inputBorderColor,
                controller: controller,
                theme: theme,
              ),
              const SizedBox(height: 16),

              CurrentLocationButton(
                isDark: isDark,
                theme: theme,
                controller: controller,
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
              LocationName(
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
                  Latitude(
                    labelColor: labelColor,
                    controller: controller,
                    isDark: isDark,
                    inputFillColor: inputFillColor,
                    inputBorderColor: inputBorderColor,
                    theme: theme,
                  ),
                  const SizedBox(width: 16),

                  Longitude(
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
            ],
          ),
        ),
      ),
    );
  }
}
