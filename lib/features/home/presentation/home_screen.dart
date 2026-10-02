import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/home/presentation/widgets/home_section_header.dart';
import 'package:my_logs/features/home/presentation/widgets/home_stat_card.dart';
import 'package:my_logs/features/home/presentation/widgets/home_tile.dart';
import 'package:my_logs/features/home/presentation/widgets/continue_watching_card.dart';
import 'package:my_logs/features/home/presentation/widgets/currently_reading_tile.dart';

import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasks = ref.watch(todayTasksProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final continueWatching = ref.watch(continueWatchingProvider);
    final currentlyReading = ref.watch(currentlyReadingProvider);

    const sectionGap = SizedBox(height: 18.0);
    const itemGap = SizedBox(height: 8.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          color: Colors.black,
          tooltip: 'Workspace Menu',
          onPressed: () {
            if (rootScaffoldKey.currentState?.isDrawerOpen == true) {
              rootScaffoldKey.currentState?.closeDrawer();
            } else {
              rootScaffoldKey.currentState?.openDrawer();
            }
          },
        ),
        title: Text('Home',
            style: AppTypography.headlineLgMobile.copyWith(color: Colors.black)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.onSurfaceVariant,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            color: AppColors.onSurfaceVariant,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // ── Quick Stats Row ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: HomeStatCard(
                  value: '${todayTasks.length}',
                  label: 'Tasks today',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.primaryContainer,
                  onTap: () => context.go('/tasks'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: HomeStatCard(
                  value: '${todayReminders.length}',
                  label: 'Reminders',
                  icon: Icons.alarm_rounded,
                  color: AppColors.tertiaryContainer,
                  onTap: () => context.go('/reminders'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: HomeStatCard(
                  value: '${continueWatching.length}',
                  label: 'Watching',
                  icon: Icons.visibility_outlined,
                  color: AppColors.secondaryContainer,
                  onTap: () => context.go('/watch'),
                ),
              ),
            ],
          ),
          sectionGap,

          // ── Today's Tasks ────────────────────────────────────────────────────
          if (todayTasks.isNotEmpty) ...[
            HomeSectionHeader(
              title: "Today's Tasks",
              actionLabel: 'See all',
              onAction: () => context.go('/tasks'),
            ),
            itemGap,
            ...todayTasks.take(4).map((t) => HomeTile(
                  leading: Icon(
                    t.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: t.isCompleted ? AppColors.primary : AppColors.outline,
                    size: 20,
                  ),
                  title: t.title,
                  subtitle: t.dueDate != null ? AppDateUtils.formatDate(t.dueDate!) : null,
                  onTap: () => context.go('/tasks'),
                )),
            sectionGap,
          ],

          // ── Today's Reminders ────────────────────────────────────────────────
          if (todayReminders.isNotEmpty) ...[
            HomeSectionHeader(
              title: 'Reminders Today',
              actionLabel: 'See all',
              onAction: () => context.go('/reminders'),
            ),
            itemGap,
            ...todayReminders.take(3).map((r) => HomeTile(
                  leading: const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
                  title: r.title,
                  subtitle: AppDateUtils.formatTime(r.scheduledTime),
                  onTap: () => context.go('/reminders'),
                )),
            sectionGap,
          ],

          // ── Continue Watching ────────────────────────────────────────────────
          if (continueWatching.isNotEmpty) ...[
            HomeSectionHeader(
              title: 'Continue Watching',
              actionLabel: 'Watch Hub',
              onAction: () => context.go('/watch'),
            ),
            itemGap,
            SizedBox(
              height: 175,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: continueWatching.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final item = continueWatching[i];
                  return ContinueWatchingCard(
                    item: item,
                    onTap: () => context.push(_watchDetailRoute(item)),
                  );
                },
              ),
            ),
            sectionGap,
          ],

          // ── Currently Reading ────────────────────────────────────────────────
          if (currentlyReading.isNotEmpty) ...[
            HomeSectionHeader(
              title: 'Currently Reading',
              actionLabel: 'Read Tracker',
              onAction: () => context.go('/read'),
            ),
            itemGap,
            ...currentlyReading.take(3).map((book) => CurrentlyReadingTile(
                  book: book,
                  onTap: () => context.push('/read/${book.id}'),
                )),
            sectionGap,
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _watchDetailRoute(MediaItem item) {
    final base = switch (item.category) {
      MediaCategory.movie => '/watch/movies',
      MediaCategory.animatedMovie => '/watch/animated',
      MediaCategory.anime => '/watch/anime',
    };
    return '$base/${item.id}';
  }
}
