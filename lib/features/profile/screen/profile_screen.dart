import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/core/widgets/custom_button_2.dart';
import 'package:field_track_todo/features/profile/controller/profile_controller.dart';
import 'package:field_track_todo/features/profile/widgets/menu_item.dart';
import 'package:field_track_todo/features/profile/widgets/profile_card.dart';
import 'package:field_track_todo/features/profile/widgets/task_and_location_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(profileControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg = isDark
        ? AppColors.darkProfileCardBg
        : AppColors.lightProfileCardBg;
    final Color avatarBg = isDark
        ? AppColors.darkProfileAvatarBg
        : AppColors.lightProfileAvatarBg;
    final Color iconBg = isDark
        ? AppColors.darkProfileIconBg
        : AppColors.lightProfileIconBg;
    final Color dividerColor = isDark
        ? AppColors.darkProfileDivider
        : AppColors.lightProfileDivider;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              ProfileCard(
                cardBg: cardBg,
                isDark: isDark,
                avatarBg: avatarBg,
                controller: controller,
                theme: theme,
              ),
              const SizedBox(height: 16),

              TaskAndLocationCounter(
                cardBg: cardBg,
                controller: controller,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              Material(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    MenuItem(
                      icon: Icons.person_outline,
                      label: 'Edit profile',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(color: dividerColor, height: 1, thickness: 1),
                    MenuItem(
                      icon: Icons.notifications_none_outlined,
                      label: 'Notifications',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(color: dividerColor, height: 1, thickness: 1),
                    MenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      iconBg: iconBg,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(color: dividerColor, height: 1, thickness: 1),
                    MenuItem(
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
