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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: AppTypography.headlineMd.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                note.content,
                style: AppTypography.bodyMd.copyWith(fontSize: 13, color: const Color(0xFF555555)),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppDateUtils.formatShortDate(note.updatedAt),
              style: AppTypography.labelMd.copyWith(color: const Color(0xFF888888), fontSize: 11),
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
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
