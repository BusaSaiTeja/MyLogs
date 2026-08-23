import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/presentation/widgets/poster_mosaic.dart';

class WatchCategoryCard extends StatelessWidget {
  const WatchCategoryCard({
    super.key,
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
      elevation: 2,
      shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.stackGap),
          child: Row(
            children: [
              PosterMosaic(urls: posterUrls, singlePoster: singlePoster),
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
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.outlineVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
