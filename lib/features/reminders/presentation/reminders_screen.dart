import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/reminders/presentation/widgets/reminder_tile.dart';

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
                return ReminderTile(
                  reminder: r,
                  onToggle: () => ref.read(reminderListProvider.notifier).toggle(r.id),
                  onTap: () => context.push('/reminders/${r.id}/edit'),
                  onDelete: () => ref.read(reminderListProvider.notifier).delete(r.id),
                );
              },
            ),
    );
  }
}
