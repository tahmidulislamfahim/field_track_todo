import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/core/widgets/custom_button_2.dart';
import 'package:field_track_todo/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate ProfileController
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom layout colors
    final Color cardBg = isDark ? const Color(0xFF161B26) : Colors.white;
    final Color avatarBg = isDark ? const Color(0xFF0F2D2A) : const Color(0xFFE6F4F1);
    final Color iconBg = isDark ? const Color(0xFF252D3D) : const Color(0xFFF3F4F6);
    final Color dividerColor = isDark ? const Color(0xFF252D3D) : const Color(0xFFE5E7EB);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Profile',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Profile Card (Initials, Name, Email, Role)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  children: [
                    // Circle Avatar
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: avatarBg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Obx(
                          () => Text(
                            controller.initials.value,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Obx(
                      () => Text(
                        controller.name.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Email
                    Obx(
                      () => Text(
                        controller.email.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field User Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Obx(
                            () => Text(
                              controller.role.value,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Side-by-Side Statistics Cards
              Row(
                children: [
                  // Tasks Stats
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              controller.tasksDoneToday.value,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tasks done today',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Locations Stats
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              '${controller.activeLocationsCount.value}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active locations',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Menu Card
              Material(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      label: 'Edit profile',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(color: dividerColor, height: 1, thickness: 1),
                    _buildMenuItem(
                      icon: Icons.notifications_none_outlined,
                      label: 'Notifications',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(color: dividerColor, height: 1, thickness: 1),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(color: dividerColor, height: 1, thickness: 1),
                    _buildMenuItem(
                      icon: Icons.help_outline_outlined,
                      label: 'Help & support',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sign Out Button using CustomButton2
              CustomButton2(
                text: 'Sign out',
                textColor: AppColors.red,
                borderColor: AppColors.red,
                icon: const Icon(
                  Icons.logout_outlined,
                  color: AppColors.red,
                  size: 20,
                ),
                onPressed: controller.signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for Menu Items
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color iconBg,
    required bool isDark,
    required VoidCallback onTap,
  }) {
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
