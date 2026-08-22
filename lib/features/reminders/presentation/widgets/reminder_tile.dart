import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';

class ReminderTile extends StatelessWidget {
  const ReminderTile({
    super.key,
    required this.reminder,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final ReminderItem reminder;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Row(
          children: [
            const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.title, style: AppTypography.bodyLg),
                    Text(
                      '${AppDateUtils.formatTime(reminder.scheduledTime)} • ${reminder.recurrence.label}',
                      style: AppTypography.labelMdOutline(),
                    ),
                  ],
                ),
              ),
            ),
            Switch(
              value: reminder.isEnabled,
              onChanged: (_) => onToggle(),
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
