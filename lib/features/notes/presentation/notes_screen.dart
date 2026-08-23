import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/notes/application/note_providers.dart';
import 'package:my_logs/features/notes/presentation/widgets/note_card.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  int _selectedCategoryIndex = 0;

  void _showAddCategoryDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category Tag'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Category name (e.g. Finance, Fitness)',
          ),
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final newCat = ctrl.text.trim();
              if (newCat.isNotEmpty) {
                ref.read(noteCategoriesProvider.notifier).addCategory(newCat);
                final updatedCategories = ref.read(noteCategoriesProvider);
                final newIdx = updatedCategories.indexOf(newCat);
                if (newIdx != -1) {
                  setState(() => _selectedCategoryIndex = newIdx);
                }
              }
              ctx.pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(noteListProvider);
    final categories = ref.watch(noteCategoriesProvider);
    final selectedCategory = categories[_selectedCategoryIndex.clamp(0, categories.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text('Notes',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => context.push('/notes/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category Tab Bar with + button at the end ──────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(categories.length, (i) {
                    final cat = categories[i];
                    final isSelected = i == _selectedCategoryIndex;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategoryIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            boxShadow: isSelected ? AppColors.cardShadow : null,
                          ),
                          child: Text(
                            cat,
                            style: AppTypography.labelMd.copyWith(
                              color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // ── Add Category Tag + Button ─────────────────────────────
                  GestureDetector(
                    onTap: _showAddCategoryDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text('Tag', style: AppTypography.labelMdPrimary()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ── Notes Grid ───────────────────────────────────────────────────
          Expanded(
            child: notesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (notes) {
                final filtered = selectedCategory == 'All'
                    ? notes
                    : notes.where((n) => n.tags.contains(selectedCategory)).toList();

                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.sticky_note_2_outlined,
                    title: 'No $selectedCategory notes',
                    subtitle: 'Tap + to create a note in $selectedCategory',
                    actionLabel: 'New Note',
                    onAction: () => context.push('/notes/add'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => NoteCard(
                      note: filtered[i],
                      onTap: () => context.push('/notes/${filtered[i].id}'),
                      onDelete: () => ref.read(noteListProvider.notifier).delete(filtered[i].id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
