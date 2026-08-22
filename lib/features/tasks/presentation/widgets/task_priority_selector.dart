import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';

class TaskPrioritySelector extends StatelessWidget {
  const TaskPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onPrioritySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskPriority.values.map((p) {
        final isSelected = p == selectedPriority;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: '${p.label} Priority',
              child: GestureDetector(
                onTap: () => onPrioritySelected(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: Center(
                    child: Text(
                      p.label,
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
