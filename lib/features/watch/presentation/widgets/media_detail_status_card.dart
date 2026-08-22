import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/core/widgets/rating_stars.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/watch/presentation/widgets/status_dropdown.dart';

class MediaDetailStatusCard extends StatelessWidget {
  const MediaDetailStatusCard({
    super.key,
    required this.item,
    required this.onStatusChanged,
    required this.onRatingChanged,
    required this.onIncrementEpisode,
  });

  final MediaItem item;
  final ValueChanged<MediaStatus?> onStatusChanged;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onIncrementEpisode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackGap),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status', style: AppTypography.labelMdVariant()),
                    const SizedBox(height: 4),
                    MediaStatusDropdown(
                      value: item.status,
                      onChanged: onStatusChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.stackGap),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Rating', style: AppTypography.labelMdVariant()),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RatingStars(
                        rating: item.rating,
                        starSize: 24,
                        onRatingChanged: onRatingChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Episode progress (anime/series)
          if (item.totalEpisodes != null) ...[
            const SizedBox(height: AppSpacing.stackGap),
            const Divider(color: AppColors.surfaceContainerHighest, height: 1),
            const SizedBox(height: AppSpacing.stackGap),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Episode Progress', style: AppTypography.labelMdVariant()),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${item.episodesWatched}',
                              style: AppTypography.headlineMd,
                            ),
                            TextSpan(
                              text: ' / ${item.totalEpisodes}',
                              style: AppTypography.bodyMdVariant(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded, color: AppColors.onPrimary),
                    onPressed: onIncrementEpisode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppProgressBar(
              progress: item.totalEpisodes! > 0
                  ? item.episodesWatched / item.totalEpisodes!
                  : 0,
            ),
          ],
        ],
      ),
    );
  }
}
