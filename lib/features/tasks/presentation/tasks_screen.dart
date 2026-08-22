import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/tasks/presentation/widgets/task_section_header.dart';
import 'package:my_logs/features/tasks/presentation/widgets/task_tile.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  bool _completedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayTasksProvider);
    final upcoming = ref.watch(upcomingTasksProvider);
    final completed = ref.watch(completedTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text('Tasks', style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppColors.primary,
            onPressed: () => context.push('/tasks/add'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            color: AppColors.onSurfaceVariant,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: (today.isEmpty && upcoming.isEmpty && completed.isEmpty)
          ? EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'All clear!',
              subtitle: 'Add your first task to get started',
              actionLabel: 'Add Task',
              onAction: () => context.push('/tasks/add'),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              children: [
                // ── Today ────────────────────────────────────────────────────
                if (today.isNotEmpty) ...[
                  TaskSectionHeader(title: "Today's Tasks", count: today.length),
                  const SizedBox(height: AppSpacing.unit * 2),
                  ...today.map((t) => TaskTile(
                        task: t,
                        onToggle: () => ref.read(taskListProvider.notifier).toggleComplete(t.id),
                        onTap: () => context.push('/tasks/${t.id}/edit'),
                        onDelete: () => ref.read(taskListProvider.notifier).delete(t.id),
                      )),
                  const SizedBox(height: AppSpacing.groupGap),
                ],

                // ── Upcoming ──────────────────────────────────────────────────
                if (upcoming.isNotEmpty) ...[
                  TaskSectionHeader(title: 'Upcoming', count: upcoming.length),
                  const SizedBox(height: AppSpacing.unit * 2),
                  ...upcoming.map((t) => TaskTile(
                        task: t,
                        onToggle: () => ref.read(taskListProvider.notifier).toggleComplete(t.id),
                        onTap: () => context.push('/tasks/${t.id}/edit'),
                        onDelete: () => ref.read(taskListProvider.notifier).delete(t.id),
                      )),
                  const SizedBox(height: AppSpacing.groupGap),
                ],

                // ── Completed (collapsible) ───────────────────────────────────
                if (completed.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () => setState(() => _completedExpanded = !_completedExpanded),
                    child: Row(
                      children: [
                        TaskSectionHeader(title: 'Completed', count: completed.length),
                        const Spacer(),
                        Icon(
                          _completedExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                  if (_completedExpanded) ...[
                    const SizedBox(height: AppSpacing.unit * 2),
                    ...completed.take(5).map((t) => TaskTile(
                          task: t,
                          onToggle: () =>
                              ref.read(taskListProvider.notifier).toggleComplete(t.id),
                          onTap: () => context.push('/tasks/${t.id}/edit'),
                          onDelete: () =>
                              ref.read(taskListProvider.notifier).delete(t.id),
                        )),
                  ],
                  const SizedBox(height: AppSpacing.groupGap),
                ],
              ],
            ),
    );
  }
}
