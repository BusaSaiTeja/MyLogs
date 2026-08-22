import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

/// Media watch/read status labels.
enum WatchStatus { planToWatch, watching, completed, onHold, dropped }
enum BookStatusLabel { toRead, reading, read, collection }
enum LearningStatus { notStarted, inProgress, completed }

/// Small pill-shaped status chip with low-saturation tint backgrounds.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.backgroundColor, required this.textColor});

  final String label;
  final Color backgroundColor;
  final Color textColor;

  /// Convenience constructors for each status type.
  factory StatusChip.watchStatus(String status) {
    final (bg, fg) = _watchColors(status);
    return StatusChip(label: status, backgroundColor: bg, textColor: fg);
  }

  factory StatusChip.bookStatus(String status) {
    final (bg, fg) = _bookColors(status);
    return StatusChip(label: status, backgroundColor: bg, textColor: fg);
  }

  factory StatusChip.learningStatus(String status) {
    final (bg, fg) = _learningColors(status);
    return StatusChip(label: status, backgroundColor: bg, textColor: fg);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(label, style: AppTypography.labelMd.copyWith(color: textColor, letterSpacing: 0.02)),
    );
  }

  static (Color, Color) _watchColors(String s) => switch (s.toLowerCase()) {
        'watching' => (AppColors.statusWatching, AppColors.statusWatchingText),
        'completed' || 'watched' => (AppColors.statusCompleted, AppColors.statusCompletedText),
        'on hold' => (AppColors.statusOnHold, AppColors.statusOnHoldText),
        'dropped' => (AppColors.statusDropped, AppColors.statusDroppedText),
        _ => (AppColors.statusPlanTo, AppColors.statusPlanToText), // plan to watch
      };

  static (Color, Color) _bookColors(String s) => switch (s.toLowerCase()) {
        'reading' => (AppColors.statusWatching, AppColors.statusWatchingText),
        'read' => (AppColors.statusCompleted, AppColors.statusCompletedText),
        'collection' => (AppColors.statusOnHold, AppColors.statusOnHoldText),
        _ => (AppColors.statusPlanTo, AppColors.statusPlanToText), // to read
      };

  static (Color, Color) _learningColors(String s) => switch (s.toLowerCase()) {
        'in progress' => (AppColors.statusWatching, AppColors.statusWatchingText),
        'completed' => (AppColors.statusCompleted, AppColors.statusCompletedText),
        _ => (AppColors.surfaceContainerHigh, AppColors.onSurfaceVariant),
      };
}

/// Generic genre / tag chip.
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label, this.primary = false});

  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: primary ? AppColors.secondaryFixed : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelMd.copyWith(
          color: primary ? AppColors.onSecondaryFixedVariant : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
