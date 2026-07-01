import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/location/controller/locations_controller.dart';
import 'package:field_track_todo/features/location/widgets/location_card.dart';
import 'package:field_track_todo/features/location/widgets/search_location.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(locationsControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Locations',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.createLocationScreen);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.add,
                        color: isDark ? AppColors.darkBackground : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SearchLocation(isDark: isDark, controller: controller),
              const SizedBox(height: 24),

              if (controller.filteredLocations.isEmpty)
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'No locations found',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredLocations.length,
                  itemBuilder: (context, index) {
                    final location = controller.filteredLocations[index];
                    return LocationCard(
                      location: location,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.editLocationScreen,
                        arguments: location,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createLocationScreen),
        backgroundColor: isDark
            ? AppColors.darkPrimary
            : AppColors.lightPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 4,
        child: Icon(
          Icons.add,
          color: isDark ? AppColors.darkBackground : Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
