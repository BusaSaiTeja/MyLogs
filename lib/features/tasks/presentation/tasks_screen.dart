import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/tasks/presentation/widgets/task_tile.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  int _selectedTab = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _selectedTab = index);
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayTasksProvider);
    final upcoming = ref.watch(upcomingTasksProvider);
    final completed = ref.watch(completedTasksProvider);
    final missed = ref.watch(missedTasksProvider);

    final totalPending = today.length + upcoming.length;

    final tabs = [
      "Pending ($totalPending)",
      "Completed (${completed.length})",
      "Missed (${missed.length})",
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          color: Colors.black,
          tooltip: 'Open menu',
          onPressed: () {
            if (rootScaffoldKey.currentState?.isDrawerOpen == true) {
              rootScaffoldKey.currentState?.closeDrawer();
            } else {
              rootScaffoldKey.currentState?.openDrawer();
            }
          },
        ),
        title: Text('Tasks', style: AppTypography.headlineLgMobile.copyWith(color: Colors.black)),
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
      // ── Floating Action Button (Only visible on Pending tab) ──────────────
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              heroTag: 'tasks_fab',
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              onPressed: () => context.push('/tasks/add'),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: Column(
        children: [
          // ── Shared PillTabBar with smooth sliding indicator ──────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: PillTabBar(
              tabs: tabs,
              selectedIndex: _selectedTab,
              onTabSelected: _onTabSelected,
            ),
          ),
          // ── Swipeable Task List PageView ──────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _selectedTab = i),
              children: [
                // ── Tab 0: Pending (Sections: Today + Upcoming) ─────────────
                _buildPendingTab(today: today, upcoming: upcoming),

                // ── Tab 1: Completed (Clean History View, No Add Button) ───
                _buildSimpleTaskList(
                  tasks: completed,
                  emptyIcon: Icons.check_circle_outline_rounded,
                  emptyTitle: 'No completed tasks yet',
                  emptySubtitle: 'Tasks you mark as done will appear here',
                ),

                // ── Tab 2: Missed (Clean Warning View, No Add Button) ───────
                _buildSimpleTaskList(
                  tasks: missed,
                  emptyIcon: Icons.warning_amber_rounded,
                  emptyTitle: 'No missed tasks',
                  emptySubtitle: 'Great job keeping up with deadlines!',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTab({
    required List<TaskItem> today,
    required List<TaskItem> upcoming,
  }) {
    if (today.isEmpty && upcoming.isEmpty) {
      return EmptyState(
        icon: Icons.pending_actions_rounded,
        title: 'No pending tasks',
        subtitle: 'All caught up! Tap + to create a new task',
        actionLabel: 'Add Task',
        onAction: () => context.push('/tasks/add'),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        // ── Section: Today ──────────────────────────────────────────────────
        if (today.isNotEmpty) ...[
          _sectionHeader(
            title: 'Today',
            count: today.length,
            icon: Icons.today_rounded,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 8),
          ...today.map((t) => TaskTile(
                task: t,
                showDate: false,
                onToggle: () =>
                    ref.read(taskListProvider.notifier).toggleComplete(t.id),
                onTap: () => context.push('/tasks/${t.id}/edit'),
                onDelete: () =>
                    ref.read(taskListProvider.notifier).delete(t.id),
              )),
          const SizedBox(height: 16),
        ],

        // ── Section: Upcoming ───────────────────────────────────────────────
        if (upcoming.isNotEmpty) ...[
          _sectionHeader(
            title: 'Upcoming',
            count: upcoming.length,
            icon: Icons.upcoming_rounded,
            iconColor: const Color(0xFF6366F1),
          ),
          const SizedBox(height: 8),
          ...upcoming.map((t) => TaskTile(
                task: t,
                onToggle: () =>
                    ref.read(taskListProvider.notifier).toggleComplete(t.id),
                onTap: () => context.push('/tasks/${t.id}/edit'),
                onDelete: () =>
                    ref.read(taskListProvider.notifier).delete(t.id),
              )),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _sectionHeader({
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: AppTypography.headlineMd.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTaskList({
    required List<TaskItem> tasks,
    required IconData emptyIcon,
    required String emptyTitle,
    required String emptySubtitle,
  }) {
    if (tasks.isEmpty) {
      return EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: emptySubtitle,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];
        return TaskTile(
          task: t,
          onToggle: () => ref.read(taskListProvider.notifier).toggleComplete(t.id),
          onTap: () => context.push('/tasks/${t.id}/edit'),
          onDelete: () => ref.read(taskListProvider.notifier).delete(t.id),
        );
      },
    );
  }
}
