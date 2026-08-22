import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasks = ref.watch(todayTasksProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final continueWatching = ref.watch(continueWatchingProvider);
    final currentlyReading = ref.watch(currentlyReadingProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(Icons.apps_rounded, color: AppColors.primary),
        ),
        title: Text('Home',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
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
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          // ── Greeting ────────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${AppDateUtils.greeting()}, ',
                  style: AppTypography.display.copyWith(color: AppColors.onSurface),
                ),
                TextSpan(
                  text: 'You 👋',
                  style: AppTypography.display.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppDateUtils.greetingDate(now),
            style: AppTypography.bodyLgVariant(),
          ),
          const SizedBox(height: AppSpacing.groupGap),

          // ── Quick Stats Row ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(child: _StatCard(
                value: '${todayTasks.length}',
                label: 'Tasks today',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.primaryContainer,
                onTap: () => context.go('/tasks'),
              )),
              const SizedBox(width: AppSpacing.gutter),
              Expanded(child: _StatCard(
                value: '${todayReminders.length}',
                label: 'Reminders',
                icon: Icons.alarm_rounded,
                color: AppColors.tertiaryContainer,
                onTap: () => context.go('/tasks'),
              )),
              const SizedBox(width: AppSpacing.gutter),
              Expanded(child: _StatCard(
                value: '${continueWatching.length}',
                label: 'Watching',
                icon: Icons.visibility_outlined,
                color: AppColors.secondaryContainer,
                onTap: () => context.go('/watch'),
              )),
            ],
          ),
          const SizedBox(height: AppSpacing.groupGap),

          // ── Today's Tasks ────────────────────────────────────────────────────
          if (todayTasks.isNotEmpty) ...[
            _SectionHeader(
              title: "Today's Tasks",
              actionLabel: 'See all',
              onAction: () => context.go('/tasks'),
            ),
            const SizedBox(height: AppSpacing.unit * 2),
            ...todayTasks.take(4).map((t) => _HomeTile(
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
            const SizedBox(height: AppSpacing.groupGap),
          ],

          // ── Today's Reminders ────────────────────────────────────────────────
          if (todayReminders.isNotEmpty) ...[
            _SectionHeader(
              title: 'Reminders Today',
              actionLabel: 'See all',
              onAction: () => context.go('/tasks'),
            ),
            const SizedBox(height: AppSpacing.unit * 2),
            ...todayReminders.take(3).map((r) => _HomeTile(
                  leading: const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
                  title: r.title,
                  subtitle: AppDateUtils.formatTime(r.scheduledTime),
                  onTap: () => context.go('/tasks'),
                )),
            const SizedBox(height: AppSpacing.groupGap),
          ],

          // ── Continue Watching ────────────────────────────────────────────────
          if (continueWatching.isNotEmpty) ...[
            _SectionHeader(
              title: 'Continue Watching',
              actionLabel: 'Watch Hub',
              onAction: () => context.go('/watch'),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: continueWatching.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.gutter),
                itemBuilder: (context, i) {
                  final item = continueWatching[i];
                  return _ContinueWatchingCard(
                    item: item,
                    onTap: () => context.push(_watchDetailRoute(item)),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.groupGap),
          ],

          // ── Currently Reading ────────────────────────────────────────────────
          if (currentlyReading.isNotEmpty) ...[
            _SectionHeader(
              title: 'Currently Reading',
              actionLabel: 'Read Tracker',
              onAction: () => context.go('/read'),
            ),
            const SizedBox(height: AppSpacing.unit * 2),
            ...currentlyReading.take(3).map((book) => _CurrentlyReadingTile(
                  book: book,
                  onTap: () => context.push('/read/${book.id}'),
                )),
            const SizedBox(height: AppSpacing.groupGap),
          ],

          const SizedBox(height: 32),
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

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTypography.headlineMd),
        const Spacer(),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: AppTypography.labelMdPrimary()),
          ),
      ],
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.surfaceContainerHighest),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.headlineLg.copyWith(color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.bodyMdOutline(), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Home Tile (compact row) ───────────────────────────────────────────────────
class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.leading,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: AppTypography.bodyLg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            if (subtitle != null)
              Text(subtitle!, style: AppTypography.labelMdOutline()),
          ],
        ),
      ),
    );
  }
}

// ── Continue Watching Card (horizontal scroll) ────────────────────────────────
class _ContinueWatchingCard extends StatelessWidget {
  const _ContinueWatchingCard({required this.item, required this.onTap});
  final MediaItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Container(
                  color: AppColors.surfaceContainerHigh,
                  child: item.posterUrl != null
                      ? Image.network(item.posterUrl!, fit: BoxFit.cover, width: double.infinity,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.movie_outlined, size: 36, color: AppColors.outline))
                      : const Icon(Icons.movie_outlined, size: 36, color: AppColors.outline),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(item.title,
                style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (item.totalEpisodes != null)
              Text(
                'Ep ${item.episodesWatched}/${item.totalEpisodes}',
                style: AppTypography.labelMdOutline(),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Currently Reading Tile ────────────────────────────────────────────────────
class _CurrentlyReadingTile extends StatelessWidget {
  const _CurrentlyReadingTile({required this.book, required this.onTap});
  final BookItem book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = book.totalPages != null && book.totalPages! > 0
        ? book.currentPage / book.totalPages!
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
        padding: const EdgeInsets.all(AppSpacing.gutter),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Row(
          children: [
            if (book.coverUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: SizedBox(
                  width: 48,
                  height: 72,
                  child: Image.network(book.coverUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: AppColors.surfaceContainerHigh)),
                ),
              )
            else
              Container(
                width: 48,
                height: 72,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.book_outlined, size: 24, color: AppColors.outline),
              ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(book.author, style: AppTypography.bodyMdOutline()),
                  const SizedBox(height: 8),
                  AppProgressBar(progress: progress),
                  const SizedBox(height: 4),
                  Text(
                    '${book.currentPage} / ${book.totalPages ?? '?'} pages',
                    style: AppTypography.labelMdOutline(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
