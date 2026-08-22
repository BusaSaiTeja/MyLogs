import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';

class ReminderRecurrenceSelector extends StatelessWidget {
  const ReminderRecurrenceSelector({
    super.key,
    required this.selectedRecurrence,
    required this.onRecurrenceSelected,
  });

  final ReminderRecurrence selectedRecurrence;
  final ValueChanged<ReminderRecurrence> onRecurrenceSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ReminderRecurrence.values.map((r) {
        final isSelected = r == selectedRecurrence;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: '${r.label} Recurrence',
              child: GestureDetector(
                onTap: () => onRecurrenceSelected(r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: Center(
                    child: Text(
                      r.label,
                      style: AppTypography.labelMd.copyWith(
                        color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
