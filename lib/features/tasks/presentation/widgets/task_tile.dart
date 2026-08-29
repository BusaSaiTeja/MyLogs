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
    this.showDate = true,
  });

  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool showDate;

  Color _priorityBgColor() => switch (task.priority) {
        TaskPriority.high => const Color(0xFFFEE2E2), // Soft red
        TaskPriority.medium => const Color(0xFFFEF3C7), // Soft amber
        TaskPriority.low => const Color(0xFFF1F5F9), // Soft slate
      };

  Color _priorityTextColor() => switch (task.priority) {
        TaskPriority.high => const Color(0xFFDC2626),
        TaskPriority.medium => const Color(0xFFD97706),
        TaskPriority.low => const Color(0xFF64748B),
      };

  String _priorityLabel() => switch (task.priority) {
        TaskPriority.high => 'High',
        TaskPriority.medium => 'Med',
        TaskPriority.low => 'Low',
      };

  bool _isOverdue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.isBefore(today);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate != null && _isOverdue(task.dueDate!);
    final isDueToday = task.dueDate != null && _isToday(task.dueDate!);
    final shouldDisplayDate = showDate && task.dueDate != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
        border: Border.all(
          color: task.isCompleted
              ? AppColors.outlineVariant.withValues(alpha: 0.25)
              : isOverdue
                  ? const Color(0xFFFECACA)
                  : AppColors.outlineVariant.withValues(alpha: 0.4),
          width: isOverdue && !task.isCompleted ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Leading Circular Checkbox ────────────────────────────────
                GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          width: 2.0,
                        ),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),

                // ── Middle: Task Title & Description ─────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        style: AppTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted
                              ? AppColors.outline
                              : AppColors.onSurface,
                        ),
                      ),
                      if (task.description != null &&
                          task.description!.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          task.description!.trim(),
                          style: AppTypography.bodyMdOutline().copyWith(
                            fontSize: 12.5,
                            color: task.isCompleted
                                ? AppColors.outlineVariant
                                : AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // ── Trailing Column: Date (Top) + Priority (Bottom) ──────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date (Hidden if showDate is false)
                    if (shouldDisplayDate) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 11,
                            color: isOverdue && !task.isCompleted
                                ? const Color(0xFFDC2626)
                                : isDueToday && !task.isCompleted
                                    ? AppColors.primary
                                    : AppColors.outline,
                          ),
                          const SizedBox(width: 3.5),
                          Text(
                            isDueToday
                                ? 'Today'
                                : AppDateUtils.formatShortDate(task.dueDate!),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isOverdue && !task.isCompleted
                                  ? const Color(0xFFDC2626)
                                  : isDueToday && !task.isCompleted
                                      ? AppColors.primary
                                      : AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Priority Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.5, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: _priorityBgColor(),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (task.priority == TaskPriority.high) ...[
                            const Icon(
                              Icons.local_fire_department_rounded,
                              size: 11,
                              color: Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 2),
                          ],
                          Text(
                            _priorityLabel(),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: _priorityTextColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
