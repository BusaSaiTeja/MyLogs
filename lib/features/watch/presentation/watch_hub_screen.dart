import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/presentation/widgets/watch_category_card.dart';

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
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text('Watch Hub', style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Watch Hub', style: AppTypography.headlineLg),
            const SizedBox(height: 16.0),
            WatchCategoryCard(
              title: 'Movies',
              itemCount: stats.movieCount,
              posterUrls: const [
                'https://images.unsplash.com/photo-1608178398319-48f814d0750c?w=200',
                'https://images.unsplash.com/photo-1514565131-fce0801e6785?w=200',
                'https://images.unsplash.com/photo-1434564764349-4803f97b8de3?w=200',
              ],
              onTap: () => context.go('/watch/movies'),
            ),
            const SizedBox(height: 12.0),
            WatchCategoryCard(
              title: 'Animated Movies',
              itemCount: stats.animatedCount,
              posterUrls: const [
                'https://images.unsplash.com/photo-1595120547202-f51a44451cb7?w=200',
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200',
              ],
              singlePoster: true,
              onTap: () => context.go('/watch/animated'),
            ),
            const SizedBox(height: 12.0),
            WatchCategoryCard(
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
