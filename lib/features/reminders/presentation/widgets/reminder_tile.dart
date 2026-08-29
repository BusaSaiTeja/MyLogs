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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppColors.cardShadow,
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
                    '${AppDateUtils.formatTime(reminder.scheduledTime)} • ${(reminder.recurrence == ReminderRecurrence.custom && reminder.customDaysText != null && reminder.customDaysText!.isNotEmpty) ? reminder.customDaysText! : reminder.recurrence.label}',
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
    );
  }
}
