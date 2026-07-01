import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/features/sync/controller/sync_controller.dart';
import 'package:field_track_todo/features/sync/widgets/internet_connectionstatus.dart';
import 'package:field_track_todo/features/sync/widgets/pending_sync_count.dart';
import 'package:field_track_todo/features/sync/widgets/sync_item_card.dart';
import 'package:field_track_todo/features/sync/widgets/sync_now_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncScreen extends ConsumerWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(syncControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg = isDark ? AppColors.darkFieldBackground : Colors.white;
    final Color warningBg = isDark
        ? AppColors.darkWarningBg
        : AppColors.lightWarningBg;
    final Color warningFg = isDark
        ? AppColors.darkWarningText
        : AppColors.lightWarningText;

    final Color syncIconBg = isDark
        ? AppColors.darkSyncCircleBg
        : AppColors.lightSyncCircleBg;

    final list = controller.pendingChanges;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sync',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              InternetConnectionstatus(
                controller: controller,
                warningBg: warningBg,
                warningFg: warningFg,
              ),

              PendingSyncCount(
                controller: controller,
                cardBg: cardBg,
                isDark: isDark,
                syncIconBg: syncIconBg,
                theme: theme,
              ),
              const SizedBox(height: 32),

              if (list.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WAITING TO UPLOAD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return SyncItemCard(item: list[index]);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              SyncNowButton(
                controller: controller,
                theme: theme,
                isDark: isDark,
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
