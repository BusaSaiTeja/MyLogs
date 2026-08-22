import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/notes/application/note_providers.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(noteListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text('Notes',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppColors.primary,
            onPressed: () => context.push('/notes/add'),
          ),
        ],
      ),
      body: notesAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notes) => notes.isEmpty
            ? EmptyState(
                icon: Icons.sticky_note_2_outlined,
                title: 'No notes yet',
                subtitle: 'Tap + to create your first note',
                actionLabel: 'New Note',
                onAction: () => context.push('/notes/add'),
              )
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.gutter,
                    mainAxisSpacing: AppSpacing.gutter,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, i) => _NoteCard(
                    note: notes[i],
                    onTap: () => context.push('/notes/${notes[i].id}'),
                    onDelete: () => ref.read(noteListProvider.notifier).delete(notes[i].id),
                  ),
                ),
              ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.onTap, required this.onDelete});
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
