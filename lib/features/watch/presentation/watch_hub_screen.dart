import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/presentation/widgets/watch_category_card.dart';

import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

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
        title: Text('Watch Hub', style: AppTypography.headlineLgMobile.copyWith(color: Colors.black)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories', style: AppTypography.headlineLg),
            const SizedBox(height: 16.0),

            // ── Movies Card ──────────────────────────────────────────────────
            WatchCategoryCard(
              title: 'Movies',
              subtitle: 'Feature films, reviews & ratings',
              itemCount: stats.movieCount,
              icon: Icons.movie_filter_rounded,
              gradientColors: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
              onTap: () => context.go('/watch/movies'),
            ),
            const SizedBox(height: 12.0),

            // ── Animated Movies Card ─────────────────────────────────────────
            WatchCategoryCard(
              title: 'Animated Movies',
              subtitle: 'Animated features & classics',
              itemCount: stats.animatedCount,
              icon: Icons.auto_awesome_rounded,
              gradientColors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
              onTap: () => context.go('/watch/animated'),
            ),
            const SizedBox(height: 12.0),

            // ── Anime Card ───────────────────────────────────────────────────
            WatchCategoryCard(
              title: 'Anime',
              subtitle: 'Anime series & seasonal releases',
              itemCount: stats.animeCount,
              icon: Icons.tv_rounded,
              gradientColors: const [Color(0xFFEC4899), Color(0xFF8B5CF6)],
              onTap: () => context.go('/watch/anime'),
            ),
          ],
        ),
      ),
    );
  }
}
