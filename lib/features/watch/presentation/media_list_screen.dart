import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/core/widgets/status_chip.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

/// Reusable list screen for Movies, Animated Movies, and Anime.
/// Category is injected via [category]; filtered by [MediaStatus] tabs.
class MediaListScreen extends ConsumerStatefulWidget {
  const MediaListScreen({super.key, required this.category});
  final MediaCategory category;

  @override
  ConsumerState<MediaListScreen> createState() => _MediaListScreenState();
}

class _MediaListScreenState extends ConsumerState<MediaListScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';

  static const _tabs = ['Plan to Watch', 'Watching', 'Completed', 'On Hold', 'Dropped'];
  static const _statuses = [
    MediaStatus.planToWatch,
    MediaStatus.watching,
    MediaStatus.completed,
    MediaStatus.onHold,
    MediaStatus.dropped,
  ];

  String get _addRoute => switch (widget.category) {
        MediaCategory.movie => '/watch/movies/add',
        MediaCategory.animatedMovie => '/watch/animated/add',
        MediaCategory.anime => '/watch/anime/add',
      };

  String _detailRoute(String id) => switch (widget.category) {
        MediaCategory.movie => '/watch/movies/$id',
        MediaCategory.animatedMovie => '/watch/animated/$id',
        MediaCategory.anime => '/watch/anime/$id',
      };

  @override
  Widget build(BuildContext context) {
    final currentStatus = _statuses[_selectedTab];
    final items = ref.watch(mediaByCategoryAndStatus((widget.category, currentStatus)));
    final filtered = _searchQuery.isEmpty
        ? items
        : items
            .where((m) => m.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text(widget.category.label,
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppColors.primary,
            onPressed: () => context.push(_addRoute),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding, AppSpacing.stackGap, AppSpacing.containerPadding, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.category.label.toLowerCase()}...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.outline),
                    ),
                    style: AppTypography.bodyLg,
                  ),
                ),
              ],
            ),
          ),
          // ── Tab bar ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding, vertical: AppSpacing.stackGap),
            child: PillTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onTabSelected: (i) => setState(() => _selectedTab = i),
            ),
          ),
          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.movie_outlined,
                    title: 'Nothing here yet',
                    subtitle: 'Add your first ${widget.category.label.toLowerCase()}',
                    actionLabel: 'Add',
                    onAction: () => context.push(_addRoute),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.containerPadding,
                        0,
                        AppSpacing.containerPadding,
                        AppSpacing.groupGap),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.unit * 2),
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      return _MediaCard(
                        item: item,
                        onTap: () => context.push(_detailRoute(item.id)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.item, required this.onTap});
  final MediaItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.stackGap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: SizedBox(
                  width: 96,
                  height: 144,
                  child: item.posterUrl != null
                      ? Image.network(item.posterUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const _PosterPlaceholder())
                      : const _PosterPlaceholder(),
                ),
              ),
              const SizedBox(width: AppSpacing.stackGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(item.title,
                              style: AppTypography.headlineMd,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (item.rating != null) ...[
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.starAmber, size: 16),
                              const SizedBox(width: 2),
                              Text(item.rating!.toStringAsFixed(1),
                                  style: AppTypography.labelMd),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (item.year != null) item.year.toString(),
                        if (item.totalEpisodes != null) '${item.totalEpisodes} eps',
                      ].join(' • '),
                      style: AppTypography.bodyMdOutline(),
                    ),
                    if (item.totalEpisodes != null && item.totalEpisodes! > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Ep ${item.episodesWatched} / ${item.totalEpisodes}',
                        style: AppTypography.bodyMdVariant(),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.genres
                          .take(2)
                          .map((g) => TagChip(label: g, primary: item.genres.indexOf(g) == 0))
                          .toList(),
                    ),
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

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceContainerHigh,
      child: Center(child: Icon(Icons.movie_outlined, color: AppColors.outline, size: 32)),
    );
  }
}
