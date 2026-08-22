import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';

class PathStepTile extends StatelessWidget {
  const PathStepTile({super.key, required this.step, required this.onToggle});
  final PathStep step;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
      padding: const EdgeInsets.all(AppSpacing.stackGap),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: step.isCompleted ? AppColors.primary.withValues(alpha: 0.3) : AppColors.surfaceContainerHighest,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number / check circle
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.isCompleted ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: step.isCompleted ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
              ),
              child: step.isCompleted
                  ? const Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 16)
                  : Center(
                      child: Text(
                        '${step.order}',
                        style: AppTypography.labelMd.copyWith(color: AppColors.outline),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.stackGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: step.isCompleted
                      ? AppTypography.bodyLg.copyWith(
                          color: AppColors.outline,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.outline,
                        )
                      : AppTypography.bodyLg,
                ),
                if (step.description != null) ...[
                  const SizedBox(height: 4),
                  Text(step.description!, style: AppTypography.bodyMdVariant()),
                ],
                if (step.resourceUrl != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.link_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          step.resourceUrl!,
                          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
