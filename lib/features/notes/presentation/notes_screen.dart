import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/notes/application/note_providers.dart';
import 'package:my_logs/features/notes/presentation/widgets/note_card.dart';

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
                  itemBuilder: (context, i) => NoteCard(
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
