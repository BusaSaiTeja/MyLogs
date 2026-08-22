import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class ReminderTimePickerTile extends StatelessWidget {
  const ReminderTimePickerTile({
    super.key,
    required this.scheduledTime,
    required this.onTap,
  });

  final DateTime scheduledTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted = '${scheduledTime.day}/${scheduledTime.month}/${scheduledTime.year} '
        '${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Row(
          children: [
            const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(formatted, style: AppTypography.bodyLg),
          ],
        ),
      ),
    );
  }
}
