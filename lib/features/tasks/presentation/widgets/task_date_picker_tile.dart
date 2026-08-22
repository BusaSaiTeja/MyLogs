import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class TaskDatePickerTile extends StatelessWidget {
  const TaskDatePickerTile({
    super.key,
    required this.dueDate,
    required this.onTap,
  });

  final DateTime? dueDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = dueDate != null
        ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
        : 'Select date';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Text(
          text,
          style: dueDate != null
              ? AppTypography.bodyLg
              : AppTypography.bodyLg.copyWith(color: AppColors.outline),
        ),
      ),
    );
  }
}
