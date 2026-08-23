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
    this.customTextController,
    this.onCustomTextChanged,
  });

  final ReminderRecurrence selectedRecurrence;
  final ValueChanged<ReminderRecurrence> onRecurrenceSelected;
  final TextEditingController? customTextController;
  final ValueChanged<String>? onCustomTextChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ReminderRecurrence.values.map((r) {
              final isSelected = r == selectedRecurrence;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: '${r.label} Recurrence',
                  child: GestureDetector(
                    onTap: () => onRecurrenceSelected(r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        boxShadow: isSelected ? AppColors.cardShadow : null,
                      ),
                      child: Center(
                        child: Text(
                          r.label,
                          style: AppTypography.labelMd.copyWith(
                            color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (selectedRecurrence == ReminderRecurrence.custom) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Recurrence Rule',
                  style: AppTypography.labelMdPrimary().copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: customTextController,
                  onChanged: onCustomTextChanged,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Every 2 days, or Mon, Wed, Fri',
                    prefixIcon: Icon(Icons.edit_calendar_rounded, size: 20, color: AppColors.primary),
                  ),
                  style: AppTypography.bodyLg,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
