import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(reminderListProvider);
    final reminders = remindersAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Reminders',
          style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppColors.primary,
            onPressed: () => context.push('/reminders/add'),
          ),
        ],
      ),
      body: reminders.isEmpty
          ? EmptyState(
              icon: Icons.alarm_rounded,
              title: 'No reminders set',
              subtitle: 'Set reminders for your daily routines & tasks',
              actionLabel: 'Add Reminder',
              onAction: () => context.push('/reminders/add'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              itemCount: reminders.length,
              itemBuilder: (context, i) {
                final r = reminders[i];
                return Dismissible(
                  key: Key(r.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref.read(reminderListProvider.notifier).delete(r.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/reminders/${r.id}/edit'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.title, style: AppTypography.bodyLg),
                                Text(
                                  '${AppDateUtils.formatTime(r.scheduledTime)} • ${r.recurrence.label}',
                                  style: AppTypography.labelMdOutline(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Switch(
                          value: r.isEnabled,
                          onChanged: (_) => ref.read(reminderListProvider.notifier).toggle(r.id),
                          activeThumbColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
