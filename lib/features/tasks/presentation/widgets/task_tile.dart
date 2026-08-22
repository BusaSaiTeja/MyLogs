import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  Color _priorityColor() => switch (task.priority) {
        TaskPriority.high => AppColors.priorityHigh,
        TaskPriority.medium => AppColors.primaryContainer,
        TaskPriority.low => AppColors.outlineVariant,
      };

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Row(
            children: [
              // Priority dot
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: _priorityColor(),
                  shape: BoxShape.circle,
                ),
              ),
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted ? AppColors.primary : AppColors.outline,
                      width: 2,
                    ),
                    color: task.isCompleted ? AppColors.primary : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: task.isCompleted
                          ? AppTypography.bodyLg.copyWith(
                              color: AppColors.outline,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.outline,
                            )
                          : AppTypography.bodyLg,
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            AppDateUtils.formatDate(task.dueDate!),
                            style: AppTypography.labelMdOutline(),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
