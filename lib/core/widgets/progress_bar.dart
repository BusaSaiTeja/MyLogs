import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

/// Thin progress bar with optional label overlay.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress, // 0.0 – 1.0
    this.height = 8.0,
    this.backgroundColor = AppColors.surfaceContainerHighest,
    this.foregroundColor = AppColors.primary,
  });

  final double progress;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: clamped,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
    );
  }
}

/// Progress bar with labelled text above showing current/total and percent.
class LabelledProgressBar extends StatelessWidget {
  const LabelledProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.label,
  });

  final int current;
  final int total;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? current / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (label != null)
              Text(label!, style: AppTypography.labelMdVariant()),
            Text(
              '${(pct * 100).round()}%',
              style: AppTypography.labelMdVariant(),
            ),
            Text(
              '$current / $total',
              style: AppTypography.labelMdVariant(),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AppProgressBar(progress: pct),
      ],
    );
  }
}
