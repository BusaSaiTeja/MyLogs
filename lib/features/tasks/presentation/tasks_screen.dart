import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';

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
                  _SectionHeader(title: "Today's Tasks", count: today.length),
                  const SizedBox(height: AppSpacing.unit * 2),
                  ...today.map((t) => _TaskTile(
                        task: t,
                        onToggle: () => ref.read(taskListProvider.notifier).toggleComplete(t.id),
                        onTap: () => context.push('/tasks/${t.id}/edit'),
                        onDelete: () => ref.read(taskListProvider.notifier).delete(t.id),
                      )),
                  const SizedBox(height: AppSpacing.groupGap),
                ],



                // ── Upcoming ──────────────────────────────────────────────────
                if (upcoming.isNotEmpty) ...[
                  _SectionHeader(title: 'Upcoming', count: upcoming.length),
                  const SizedBox(height: AppSpacing.unit * 2),
                  ...upcoming.map((t) => _TaskTile(
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
                        _SectionHeader(title: 'Completed', count: completed.length),
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
                    ...completed.take(5).map((t) => _TaskTile(
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

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTypography.headlineMd),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text('$count', style: AppTypography.labelMd),
        ),
      ],
    );
  }
}

// ── Task Tile ──────────────────────────────────────────────────────────────────
class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });
  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  Color _priorityColor() => switch (task.priority) {
        TaskPriority.high => AppColors.priorityHigh,
        TaskPriority.medium => AppColors.primaryContainer,
        TaskPriority.low => AppColors.outlineVariant,
      };

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Row(
            children: [
              // Priority dot
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: _priorityColor(),
                  shape: BoxShape.circle,
                ),
              ),
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted ? AppColors.primary : AppColors.outline,
                      width: 2,
                    ),
                    color: task.isCompleted ? AppColors.primary : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: task.isCompleted
                          ? AppTypography.bodyLg.copyWith(
                              color: AppColors.outline,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.outline,
                            )
                          : AppTypography.bodyLg,
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            AppDateUtils.formatDate(task.dueDate!),
                            style: AppTypography.labelMdOutline(),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


