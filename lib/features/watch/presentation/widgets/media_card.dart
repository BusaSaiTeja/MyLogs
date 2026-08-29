import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/status_chip.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
  });

  final MediaItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final cardChild = Material(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: SizedBox(
                  width: 96,
                  height: 144,
                  child: item.posterUrl != null
                      ? Image.network(
                          item.posterUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const _PosterPlaceholder(),
                        )
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
                          child: Text(
                            item.title,
                            style: AppTypography.headlineMd,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.rating != null) ...[
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.starAmber,
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                item.rating!.toStringAsFixed(1),
                                style: AppTypography.labelMd,
                              ),
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

    return cardChild;
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
