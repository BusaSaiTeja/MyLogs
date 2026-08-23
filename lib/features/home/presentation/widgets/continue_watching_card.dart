import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

class ContinueWatchingCard extends StatelessWidget {
  const ContinueWatchingCard({super.key, required this.item, required this.onTap});
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
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: AppColors.cardShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  child: item.posterUrl != null
                      ? Image.network(
                          item.posterUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, _, _) => const Icon(Icons.movie_outlined, size: 36, color: AppColors.outline),
                        )
                      : const Icon(Icons.movie_outlined, size: 36, color: AppColors.outline),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
