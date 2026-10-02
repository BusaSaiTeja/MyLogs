import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';
import 'package:my_logs/features/learning_paths/presentation/widgets/learning_path_card.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';
import 'package:my_logs/features/notes/presentation/widgets/note_card.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';
import 'package:my_logs/features/read/presentation/widgets/book_card.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';
import 'package:my_logs/features/reminders/presentation/widgets/reminder_tile.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/tasks/presentation/widgets/task_tile.dart';
import 'package:my_logs/features/watch/presentation/widgets/watch_category_card.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/domain/models/feature_definition.dart';

class FeaturePreviewScreen extends ConsumerStatefulWidget {
  final FeatureDefinition feature;

  const FeaturePreviewScreen({
    super.key,
    required this.feature,
  });

  @override
  ConsumerState<FeaturePreviewScreen> createState() => _FeaturePreviewScreenState();
}

class _FeaturePreviewScreenState extends ConsumerState<FeaturePreviewScreen> {
  // Demo interactive states
  int _selectedTabIndex = 0;
  final Set<String> _demoCompletedTaskIds = {};
  final Set<String> _demoToggledReminderIds = {'rem-1', 'rem-2'};

  @override
  Widget build(BuildContext context) {
    final activeWs = ref.watch(activeWorkspaceProvider);
    final enabledKeys = activeWs?.enabledFeatures ?? [];
    final isAdded = enabledKeys.contains(widget.feature.key);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.black,
          tooltip: 'Back to Marketplace',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text(
              widget.feature.title,
              style: AppTypography.headlineLgMobile.copyWith(color: Colors.black),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: widget.feature.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.feature.color.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Text(
                'PREVIEW',
                style: TextStyle(
                  color: widget.feature.color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ── Demo Info Banner ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: widget.feature.color.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: widget.feature.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Interactive demo with sample data (editing/creating disabled)',
                    style: TextStyle(
                      color: widget.feature.color.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Feature Screen Body ───────────────────────────────────────────
          Expanded(
            child: _buildFeatureContent(context),
          ),
        ],
      ),
      // ── Sticky Bottom Action Bar ─────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            border: const Border(
              top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.feature.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      isAdded
                          ? 'Active in ${activeWs?.name ?? 'Workspace'}'
                          : 'Not added to ${activeWs?.name ?? 'Workspace'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isAdded ? const Color(0xFF10B981) : AppColors.onSurfaceVariant,
                        fontWeight: isAdded ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAdded
                      ? const Color(0xFFDC2626).withValues(alpha: 0.10)
                      : widget.feature.color,
                  foregroundColor: isAdded ? const Color(0xFFDC2626) : Colors.white,
                  elevation: isAdded ? 0 : 2,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isAdded
                        ? const BorderSide(color: Color(0xFFDC2626), width: 1)
                        : BorderSide.none,
                  ),
                ),
                onPressed: () {
                  if (activeWs != null) {
                    ref
                        .read(workspaceListProvider.notifier)
                        .toggleFeature(activeWs.id, widget.feature.key);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isAdded
                              ? 'Removed ${widget.feature.title} from workspace'
                              : 'Added ${widget.feature.title} to workspace!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  isAdded ? Icons.remove_circle_outline_rounded : Icons.add_rounded,
                  size: 18,
                ),
                label: Text(
                  isAdded ? 'Remove Feature' : 'Add to Workspace',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureContent(BuildContext context) {
    switch (widget.feature.key) {
      case 'notes':
        return _buildNotesDemo();
      case 'tasks':
        return _buildTasksDemo();
      case 'reminders':
        return _buildRemindersDemo();
      case 'read':
        return _buildReadDemo();
      case 'watch':
        return _buildWatchDemo(context);
      case 'learning_paths':
        return _buildLearningPathsDemo();
      default:
        return Center(
          child: Text('No preview available for ${widget.feature.title}'),
        );
    }
  }

  // ── 1. Notes Demo ──────────────────────────────────────────────────────────
  Widget _buildNotesDemo() {
    final sampleNotes = [
      NoteItem(
        id: 'demo-note-1',
        title: '💡 Project Architecture Roadmap',
        content:
            'Implement Clean Architecture with Riverpod 2.x state management.\nSeparate feature layers into presentation, domain, and data repositories.',
        tags: const ['Architecture', 'Flutter', 'Dev'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now(),
      ),
      NoteItem(
        id: 'demo-note-2',
        title: '📚 High-Performance Engineering Books',
        content:
            '1. Designing Data-Intensive Applications\n2. Staff Engineer path & leadership\n3. Clean Code & Refactoring principles',
        tags: const ['Books', 'Reading', 'Growth'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      NoteItem(
        id: 'demo-note-3',
        title: '🎯 Weekly Workout & Fitness Regimen',
        content:
            '• Monday/Wednesday/Friday: Strength & upper body\n• Tuesday/Thursday: 5km cardio & mobility\n• Stay hydrated (3L daily)',
        tags: const ['Health', 'Fitness'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
    ];

    const categories = ['All (3)', 'Work (1)', 'Learning (1)', 'Personal (1)'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: PillTabBar(
            tabs: categories,
            selectedIndex: _selectedTabIndex,
            onTabSelected: (idx) => setState(() => _selectedTabIndex = idx),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: sampleNotes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = sampleNotes[index];
              return NoteCard(
                note: note,
                onTap: () {
                  _showInfoDialog(note.title, note.content);
                },
                onDelete: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  // ── 2. Tasks Demo ──────────────────────────────────────────────────────────
  Widget _buildTasksDemo() {
    final sampleTodayTasks = [
      TaskItem(
        id: 'task-1',
        title: 'Review PR #42 & verify migration scripts',
        description: 'Check schema migration compatibility and Riverpod providers',
        isCompleted: _demoCompletedTaskIds.contains('task-1'),
        priority: TaskPriority.high,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskItem(
        id: 'task-2',
        title: 'Prepare presentation slides for team demo',
        description: 'Highlight new workspace switcher and feature marketplace UX',
        isCompleted: _demoCompletedTaskIds.contains('task-2'),
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final sampleUpcomingTasks = [
      TaskItem(
        id: 'task-3',
        title: 'Update dependency lockfiles & run audit',
        description: 'Verify pub.dev packages and run flutter analyze',
        isCompleted: _demoCompletedTaskIds.contains('task-3'),
        priority: TaskPriority.low,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    const tabs = ['Pending (3)', 'Completed (0)', 'Missed (0)'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: PillTabBar(
            tabs: tabs,
            selectedIndex: _selectedTabIndex,
            onTabSelected: (idx) => setState(() => _selectedTabIndex = idx),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              _buildSectionHeader('Today', sampleTodayTasks.length, Icons.wb_sunny_rounded, AppColors.primary),
              const SizedBox(height: 8),
              ...sampleTodayTasks.map(
                (task) => TaskTile(
                  task: task,
                  onToggle: () {
                    setState(() {
                      if (_demoCompletedTaskIds.contains(task.id)) {
                        _demoCompletedTaskIds.remove(task.id);
                      } else {
                        _demoCompletedTaskIds.add(task.id);
                      }
                    });
                  },
                  onTap: () {},
                  onDelete: () {},
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('Upcoming', sampleUpcomingTasks.length, Icons.calendar_month_rounded, const Color(0xFF64748B)),
              const SizedBox(height: 8),
              ...sampleUpcomingTasks.map(
                (task) => TaskTile(
                  task: task,
                  onToggle: () {
                    setState(() {
                      if (_demoCompletedTaskIds.contains(task.id)) {
                        _demoCompletedTaskIds.remove(task.id);
                      } else {
                        _demoCompletedTaskIds.add(task.id);
                      }
                    });
                  },
                  onTap: () {},
                  onDelete: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 3. Reminders Demo ──────────────────────────────────────────────────────
  Widget _buildRemindersDemo() {
    final sampleReminders = [
      ReminderItem(
        id: 'rem-1',
        title: '💊 Take Daily Vitamins & Supplements',
        scheduledTime: DateTime(2026, 10, 2, 8, 30),
        isEnabled: _demoToggledReminderIds.contains('rem-1'),
        recurrence: ReminderRecurrence.daily,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ReminderItem(
        id: 'rem-2',
        title: '💧 Hydration & Posture Break',
        scheduledTime: DateTime(2026, 10, 2, 14, 0),
        isEnabled: _demoToggledReminderIds.contains('rem-2'),
        recurrence: ReminderRecurrence.daily,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ReminderItem(
        id: 'rem-3',
        title: '☁️ Weekly Cloud Backup & Archive',
        scheduledTime: DateTime(2026, 10, 4, 21, 0),
        isEnabled: _demoToggledReminderIds.contains('rem-3'),
        recurrence: ReminderRecurrence.weekly,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: sampleReminders.length,
      itemBuilder: (context, index) {
        final reminder = sampleReminders[index];
        return ReminderTile(
          reminder: reminder,
          onToggle: () {
            setState(() {
              if (_demoToggledReminderIds.contains(reminder.id)) {
                _demoToggledReminderIds.remove(reminder.id);
              } else {
                _demoToggledReminderIds.add(reminder.id);
              }
            });
          },
          onTap: () {},
          onDelete: () {},
        );
      },
    );
  }

  // ── 4. Read Tracker Demo ───────────────────────────────────────────────────
  Widget _buildReadDemo() {
    final sampleBooks = [
      BookItem(
        id: 'book-1',
        title: 'Atomic Habits',
        author: 'James Clear',
        status: BookStatus.reading,
        currentPage: 180,
        totalPages: 320,
        rating: 5.0,
        coverUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=300&q=80',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      BookItem(
        id: 'book-2',
        title: 'Clean Code: A Handbook of Agile Software',
        author: 'Robert C. Martin',
        status: BookStatus.reading,
        currentPage: 210,
        totalPages: 464,
        rating: 4.8,
        coverUrl: 'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?w=300&q=80',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    const tabs = ['Reading (2)', 'Read (5)', 'To Read (3)', 'Collection (8)'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: PillTabBar(
            tabs: tabs,
            selectedIndex: _selectedTabIndex,
            onTabSelected: (idx) => setState(() => _selectedTabIndex = idx),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: sampleBooks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final book = sampleBooks[index];
              return BookCard(
                book: book,
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  // ── 5. Watch Hub Demo ──────────────────────────────────────────────────────
  Widget _buildWatchDemo(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories', style: AppTypography.headlineLg),
          const SizedBox(height: 16.0),
          WatchCategoryCard(
            title: 'Movies',
            subtitle: 'Feature films, reviews & ratings',
            itemCount: 14,
            icon: Icons.movie_filter_rounded,
            gradientColors: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
            onTap: () {},
          ),
          const SizedBox(height: 12.0),
          WatchCategoryCard(
            title: 'TV Shows',
            subtitle: 'Series, seasons & episode progress',
            itemCount: 8,
            icon: Icons.tv_rounded,
            gradientColors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
            onTap: () {},
          ),
          const SizedBox(height: 12.0),
          WatchCategoryCard(
            title: 'Anime',
            subtitle: 'Japanese animation tracked via AniList',
            itemCount: 22,
            icon: Icons.animation_rounded,
            gradientColors: const [Color(0xFFEC4899), Color(0xFFDB2777)],
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── 6. Learning Paths Demo ─────────────────────────────────────────────────
  Widget _buildLearningPathsDemo() {
    final samplePaths = [
      LearningPath(
        id: 'path-1',
        title: 'Flutter & Dart Production Masterclass',
        description:
            'Comprehensive roadmap covering Clean Architecture, Riverpod 2.x, custom animations, and automated unit testing.',
        steps: const [
          PathStep(id: 's1', title: 'Dart 3 Patterns & Records', isCompleted: true),
          PathStep(id: 's2', title: 'Riverpod State Providers & Notifiers', isCompleted: true),
          PathStep(id: 's3', title: 'Offline-First Firestore Repositories', isCompleted: true),
          PathStep(id: 's4', title: '60/120 FPS UI & Micro-interactions', isCompleted: false),
          PathStep(id: 's5', title: 'CI/CD Pipelines & App Store Delivery', isCompleted: false),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      LearningPath(
        id: 'path-2',
        title: 'System Design & Distributed Scalability',
        description:
            'Mastering distributed caching, message queues, database indexing, and high availability design.',
        steps: const [
          PathStep(id: 's1', title: 'Database Indexing & Query Tuning', isCompleted: true),
          PathStep(id: 's2', title: 'Redis Distributed Caching Patterns', isCompleted: false),
          PathStep(id: 's3', title: 'Kafka & Event-Driven Architecture', isCompleted: false),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: samplePaths.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final path = samplePaths[index];
        final completed = path.steps.where((s) => s.isCompleted).length;
        final total = path.steps.length;
        final progress = total > 0 ? completed / total : 0.0;

        return LearningPathCard(
          path: path,
          progress: progress,
          status: '${(progress * 100).toInt()}% Done',
          onTap: () {},
          onDelete: () {},
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
