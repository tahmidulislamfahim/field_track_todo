import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/location/screen/locations_screen.dart';
import 'package:field_track_todo/features/nav_bar/controller/nav_bar_controller.dart';
import 'package:field_track_todo/features/nav_bar/widgets/nav_item.dart';
import 'package:field_track_todo/features/profile/screen/profile_screen.dart';
import 'package:field_track_todo/features/sync/screen/sync_screen.dart';
import 'package:field_track_todo/features/tasks/screen/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavBarController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color activeColor = theme.primaryColor;
    final Color inactiveColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final Color navBarBg = isDark
        ? const Color(0xFF111827)
        : Colors.white;

    final List<Widget> pages = const [
      TasksScreen(),
      LocationsScreen(),
      SyncScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: navBarBg,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(index: 0, label: 'Tasks', icon: Icons.format_list_bulleted, controller: controller, activeColor: activeColor, inactiveColor: inactiveColor),
                NavItem(index: 1, label: 'Locations', icon: Icons.location_on_outlined, controller: controller, activeColor: activeColor, inactiveColor: inactiveColor),
                NavItem(index: 2, label: 'Sync', icon: Icons.sync, controller: controller, activeColor: activeColor, inactiveColor: inactiveColor),
                NavItem(index: 3, label: 'Profile', icon: Icons.person_outline, controller: controller, activeColor: activeColor, inactiveColor: inactiveColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
