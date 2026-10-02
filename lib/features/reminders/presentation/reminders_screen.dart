import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/reminders/presentation/widgets/reminder_tile.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

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
          icon: const Icon(Icons.menu_rounded),
          color: AppColors.obsidian,
          tooltip: 'Open menu',
          onPressed: () {
            if (rootScaffoldKey.currentState?.isDrawerOpen == true) {
              rootScaffoldKey.currentState?.closeDrawer();
            } else {
              rootScaffoldKey.currentState?.openDrawer();
            }
          },
        ),
        title: Text(
          'Reminders',
          style: AppTypography.headlineLgMobile.copyWith(color: AppColors.obsidian),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurfaceVariant),
            tooltip: 'More options',
            onSelected: (value) {
              if (value == 'disable') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Disable feature (Coming in Phase 3)'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (value == 'hide') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hide feature (Coming in Phase 3)'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'disable',
                child: Row(
                  children: [
                    Icon(Icons.block_rounded, size: 20, color: AppColors.onSurfaceVariant),
                    SizedBox(width: 12),
                    Text('Disable Feature'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'hide',
                child: Row(
                  children: [
                    Icon(Icons.visibility_off_outlined, size: 20, color: AppColors.onSurfaceVariant),
                    SizedBox(width: 12),
                    Text('Hide Feature'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'reminders_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => context.push('/reminders/add'),
        child: const Icon(Icons.add_rounded),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
