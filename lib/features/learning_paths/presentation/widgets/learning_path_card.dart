import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/core/widgets/status_chip.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';

class LearningPathCard extends StatelessWidget {
  const LearningPathCard({
    super.key,
    required this.path,
    required this.progress,
    required this.status,
    required this.onTap,
    required this.onDelete,
  });

  final LearningPath path;
  final double progress;
  final String status;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final completed = path.steps.where((s) => s.isCompleted).length;

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.stackGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      path.title,
                      style: AppTypography.headlineMd,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip.learningStatus(status),
                ],
              ),
              if (path.description != null) ...[
                const SizedBox(height: 6),
                Text(
                  path.description!,
                  style: AppTypography.bodyMdVariant(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSpacing.stackGap),
              // Progress bar
              AppProgressBar(progress: progress),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '$completed / ${path.steps.length} steps',
                    style: AppTypography.labelMdVariant(),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).round()}%',
                    style: AppTypography.labelMdPrimary(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
