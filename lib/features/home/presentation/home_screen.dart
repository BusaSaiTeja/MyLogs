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

import 'package:my_logs/core/widgets/drawer_menu_button.dart';

/// Dashboard with Bento hero overview and grouped surfaces.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasks = ref.watch(todayTasksProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final continueWatching = ref.watch(continueWatchingProvider);
    final currentlyReading = ref.watch(currentlyReadingProvider);

    const sectionGap = SizedBox(height: 26.0);
    const itemGap = SizedBox(height: 10.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: const DrawerMenuButton(tooltip: 'Workspace Menu'),
        title: Text(
          'Home',
          style: AppTypography.headlineLgMobile.copyWith(color: AppColors.obsidian),
        ),
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
          // ── Asymmetric Bento Hero Overview (Breaks Dead Symmetry) ──────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Focal Card: Today's Tasks & Momentum
              Expanded(
                flex: 11,
                child: SizedBox(
                  height: 150,
                  child: HomeStatCard(
                    value: '${todayTasks.length}',
                    label: todayTasks.isEmpty
                        ? 'All tasks completed'
                        : 'Active tasks today',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.primaryContainer,
                    eyebrow: "Today's Focus",
                    isHero: true,
                    onTap: () => context.go('/tasks'),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Right Stacked Micro Cards
              Expanded(
                flex: 9,
                child: SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Expanded(
                        child: HomeStatCard(
                          value: '${todayReminders.length}',
                          label: 'Reminders',
                          icon: Icons.alarm_rounded,
                          color: AppColors.tertiaryContainer,
                          onTap: () => context.go('/reminders'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: HomeStatCard(
                          value: '${continueWatching.length}',
                          label: 'Watching',
                          icon: Icons.movie_outlined,
                          color: AppColors.secondaryContainer,
                          onTap: () => context.go('/watch'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          sectionGap,

          // ── Today's Tasks (Grouped Surface Card) ───────────────────────────
          if (todayTasks.isNotEmpty) ...[
            HomeSectionHeader(
              title: "Today's Tasks",
              actionLabel: 'See all',
              onAction: () => context.go('/tasks'),
            ),
            itemGap,
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < todayTasks.take(4).length; i++)
                    HomeTile(
                      leading: Icon(
                        todayTasks[i].isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: todayTasks[i].isCompleted ? AppColors.primary : AppColors.outline,
                        size: 20,
                      ),
                      title: todayTasks[i].title,
                      subtitle: todayTasks[i].dueDate != null
                          ? AppDateUtils.formatDate(todayTasks[i].dueDate!)
                          : null,
                      showDivider: i < todayTasks.take(4).length - 1,
                      onTap: () => context.go('/tasks'),
                    ),
                ],
              ),
            ),
            sectionGap,
          ],

          // ── Today's Reminders (Grouped Surface Card) ───────────────────────
          if (todayReminders.isNotEmpty) ...[
            HomeSectionHeader(
              title: 'Reminders Today',
              actionLabel: 'See all',
              onAction: () => context.go('/reminders'),
            ),
            itemGap,
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < todayReminders.take(3).length; i++)
                    HomeTile(
                      leading: const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
                      title: todayReminders[i].title,
                      subtitle: AppDateUtils.formatTime(todayReminders[i].scheduledTime),
                      showDivider: i < todayReminders.take(3).length - 1,
                      onTap: () => context.go('/reminders'),
                    ),
                ],
              ),
            ),
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
                separatorBuilder: (_, _) => const SizedBox(width: 12),
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
          const SizedBox(height: 24),
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
