import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/tasks/presentation/widgets/task_tile.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayTasksProvider);
    final upcoming = ref.watch(upcomingTasksProvider);
    final completed = ref.watch(completedTasksProvider);
    final missed = ref.watch(missedTasksProvider);

    final currentTasks = switch (_selectedTab) {
      0 => today,
      1 => upcoming,
      2 => completed,
      3 => missed,
      _ => today,
    };

    final (emptyIcon, emptyTitle, emptySubtitle) = switch (_selectedTab) {
      0 => (Icons.today_rounded, "No tasks for today", "Tap + to add a task for today"),
      1 => (Icons.upcoming_rounded, "No upcoming tasks", "All caught up on future tasks"),
      2 => (Icons.check_circle_outline_rounded, "No completed tasks yet", "Completed tasks will show up here"),
      3 => (Icons.warning_amber_rounded, "No missed tasks", "Great job keeping up with deadlines!"),
      _ => (Icons.task_alt_rounded, "No tasks", ""),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text('Tasks', style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => context.push('/tasks/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          // ── Shared PillTabBar matching app design system ─────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: PillTabBar(
              tabs: [
                "Today (${today.length})",
                "Upcoming (${upcoming.length})",
                "Completed (${completed.length})",
                "Missed (${missed.length})",
              ],
              selectedIndex: _selectedTab,
              onTabSelected: (i) => setState(() => _selectedTab = i),
            ),
          ),
          // ── Task List ─────────────────────────────────────────────────────
          Expanded(
            child: currentTasks.isEmpty
                ? EmptyState(
                    icon: emptyIcon,
                    title: emptyTitle,
                    subtitle: emptySubtitle,
                    actionLabel: 'Add Task',
                    onAction: () => context.push('/tasks/add'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    itemCount: currentTasks.length,
                    itemBuilder: (context, index) {
                      final t = currentTasks[index];
                      return TaskTile(
                        task: t,
                        onToggle: () => ref.read(taskListProvider.notifier).toggleComplete(t.id),
                        onTap: () => context.push('/tasks/${t.id}/edit'),
                        onDelete: () => ref.read(taskListProvider.notifier).delete(t.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
