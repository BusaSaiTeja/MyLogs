import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  final NoteItem note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  static final _palette = [
    const Color(0xFFFFF9C4), // yellow
    const Color(0xFFE8F5E9), // green
    const Color(0xFFE3F2FD), // blue
    const Color(0xFFFCE4EC), // pink
    const Color(0xFFF3E5F5), // purple
    const Color(0xFFFFF3E0), // orange
  ];

  Color get _cardColor => _palette[note.id.hashCode.abs() % _palette.length];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _confirmDelete(context),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.stackGap),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: AppTypography.headlineMd.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                note.content,
                style: AppTypography.bodyMd.copyWith(fontSize: 12, color: const Color(0xFF555555)),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  AppDateUtils.formatShortDate(note.updatedAt),
                  style: AppTypography.labelMd.copyWith(color: const Color(0xFF777777), fontSize: 11),
                ),
                const Spacer(),
                if (note.tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: note.tags.take(2).map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text(
                            t,
                            style: AppTypography.labelMd.copyWith(fontSize: 10, color: const Color(0xFF333333)),
                          ),
                        )).toList(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('Delete "${note.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ctx.pop();
              onDelete();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
