import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';

class PathProgressCard extends StatelessWidget {
  const PathProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
  });

  final int completedCount;
  final int totalCount;
  final double progress;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('$completedCount / $totalCount steps', style: AppTypography.headlineMd),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppProgressBar(progress: progress, height: 10),
        ],
      ),
    );
  }
}
