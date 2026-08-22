import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

class WatchHubScreen extends ConsumerWidget {
  const WatchHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(watchHubStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text('Watch Hub', style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            color: AppColors.onSurfaceVariant,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Watch Hub', style: AppTypography.display),
            const SizedBox(height: AppSpacing.groupGap),
            _WatchCategoryCard(
              title: 'Movies',
              itemCount: stats.movieCount,
              posterUrls: const [
                'https://images.unsplash.com/photo-1608178398319-48f814d0750c?w=200',
                'https://images.unsplash.com/photo-1514565131-fce0801e6785?w=200',
                'https://images.unsplash.com/photo-1434564764349-4803f97b8de3?w=200',
              ],
              onTap: () => context.go('/watch/movies'),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            _WatchCategoryCard(
              title: 'Animated Movies',
              itemCount: stats.animatedCount,
              posterUrls: const [
                'https://images.unsplash.com/photo-1595120547202-f51a44451cb7?w=200',
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200',
              ],
              singlePoster: true,
              onTap: () => context.go('/watch/animated'),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            _WatchCategoryCard(
              title: 'Anime',
              itemCount: stats.animeCount,
              posterUrls: const [
                'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=200',
                'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=200',
                'https://images.unsplash.com/photo-1583835746434-cf1534674b41?w=200',
              ],
              onTap: () => context.go('/watch/anime'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchCategoryCard extends StatelessWidget {
  const _WatchCategoryCard({
    required this.title,
    required this.itemCount,
    required this.posterUrls,
    required this.onTap,
    this.singlePoster = false,
  });

  final String title;
  final int itemCount;
  final List<String> posterUrls;
  final VoidCallback onTap;
  final bool singlePoster;

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
            children: [
              _PosterMosaic(urls: posterUrls, singlePoster: singlePoster),
              const SizedBox(width: AppSpacing.stackGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.headlineMd),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount items',
                      style: AppTypography.bodyMdVariant(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.outlineVariant, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosterMosaic extends StatelessWidget {
  const _PosterMosaic({required this.urls, this.singlePoster = false});
  final List<String> urls;
  final bool singlePoster;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: SizedBox(
        width: 80,
        height: 80,
        child: singlePoster || urls.length < 2
            ? _PosterImage(url: urls.isNotEmpty ? urls[0] : '')
            : Row(
                children: [
                  Expanded(child: _PosterImage(url: urls[0])),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _PosterImage(url: urls.length > 1 ? urls[1] : '')),
                        const SizedBox(height: 2),
                        Expanded(child: _PosterImage(url: urls.length > 2 ? urls[2] : '')),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: url.isEmpty
          ? const Icon(Icons.movie_outlined, color: AppColors.outline, size: 24)
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceVariant),
            ),
    );
  }
}
