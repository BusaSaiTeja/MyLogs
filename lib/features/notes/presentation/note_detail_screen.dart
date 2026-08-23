import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/notes/application/note_providers.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  const NoteDetailScreen({super.key, this.noteId, this.isNew = false});
  final String? noteId;
  final bool isNew;

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  final List<String> _selectedTags = [];
  String? _currentNoteId;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
    _currentNoteId = widget.noteId;

    if (!widget.isNew && widget.noteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final note = ref.read(noteByIdProvider(widget.noteId!));
        if (note == null) return;
        _titleCtrl.text = note.title;
        _contentCtrl.text = note.content;
        setState(() {
          _selectedTags.clear();
          _selectedTags.addAll(note.tags);
        });
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _autoSave();
    });
  }

  Future<void> _autoSave() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text;

    // Skip auto-saving if completely empty
    if (title.isEmpty && content.trim().isEmpty && _selectedTags.isEmpty) return;

    final now = DateTime.now();
    final effectiveTitle = title.isEmpty ? 'Untitled Note' : title;

    try {
      if (_currentNoteId != null) {
        final existing = ref.read(noteByIdProvider(_currentNoteId!));
        if (existing != null) {
          await ref.read(noteListProvider.notifier).updateItem(existing.copyWith(
                title: effectiveTitle,
                content: content,
                tags: List.from(_selectedTags),
                updatedAt: now,
              ));
        }
      } else {
        final newNote = NoteItem(
          id: '',
          title: effectiveTitle,
          content: content,
          tags: List.from(_selectedTags),
          createdAt: now,
          updatedAt: now,
        );
        await ref.read(noteListProvider.notifier).add(newNote);
        final list = ref.read(noteListProvider).valueOrNull ?? [];
        if (list.isNotEmpty) {
          _currentNoteId = list.first.id;
        }
      }
    } catch (_) {}
  }

  void _showAddTagDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Category Tag'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Category name (e.g. Finance, Recipes)',
          ),
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final newTag = ctrl.text.trim();
              if (newTag.isNotEmpty) {
                ref.read(noteCategoriesProvider.notifier).addCategory(newTag);
                setState(() {
                  if (!_selectedTags.contains(newTag)) {
                    _selectedTags.add(newTag);
                  }
                });
                _autoSave();
              }
              ctx.pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddTagMenu(TapDownDetails details, List<String> allCategories) {
    final remaining = allCategories.where((c) => !_selectedTags.contains(c)).toList();
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surfaceContainerLowest,
      elevation: 4,
      items: [
        ...remaining.map((tag) => PopupMenuItem<String>(
              value: tag,
              child: Row(
                children: [
                  const Icon(Icons.label_outline_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(tag, style: AppTypography.bodyLg),
                ],
              ),
            )),
        if (remaining.isNotEmpty) const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: '__NEW__',
          child: Row(
            children: [
              const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Create New Tag...', style: AppTypography.labelMdPrimary()),
            ],
          ),
        ),
      ],
    ).then((selected) {
      if (selected == null) return;
      if (selected == '__NEW__') {
        _showAddTagDialog();
      } else {
        setState(() {
          _selectedTags.add(selected);
        });
        _autoSave();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = ref.watch(noteCategoriesProvider).where((c) => c != 'All').toList();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          await _autoSave();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.onSurfaceVariant,
            onPressed: () async {
              await _autoSave();
              if (context.mounted) {
                context.canPop() ? context.pop() : context.go('/notes');
              }
            },
          ),
          title: Text(_currentNoteId == null ? 'New Note' : 'Edit Note',
              style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
          centerTitle: false,
          actions: [
            if (_currentNoteId != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.error,
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Note'),
                      content: const Text('Are you sure you want to delete this note?'),
                      actions: [
                        TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => ctx.pop(true),
                          style: TextButton.styleFrom(foregroundColor: AppColors.error),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await ref.read(noteListProvider.notifier).delete(_currentNoteId!);
                    if (context.mounted) {
                      context.canPop() ? context.pop() : context.go('/notes');
                    }
                  }
                },
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            TextField(
              controller: _titleCtrl,
              onChanged: (_) => _onTextChanged(),
              style: AppTypography.headlineLg.copyWith(fontSize: 22),
              decoration: InputDecoration(
                hintText: 'Note title',
                hintStyle: AppTypography.headlineLg.copyWith(fontSize: 22, color: AppColors.outline),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 6),

            // ── Ultra-Compact Inline Tag Bar with Instant Popup Menu ──────────
            Row(
              children: [
                const Icon(Icons.label_outline_rounded, size: 16, color: AppColors.outline),
                const SizedBox(width: 6),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ..._selectedTags.map((tag) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTags.remove(tag);
                                  });
                                  _autoSave();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(tag, style: AppTypography.labelMdPrimary().copyWith(fontSize: 11)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.close_rounded, size: 12, color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        GestureDetector(
                          onTapDown: (details) => _showAddTagMenu(details, allCategories),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 2),
                                Text('Tag', style: AppTypography.labelMdPrimary().copyWith(fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackGap),

            TextField(
              controller: _contentCtrl,
              onChanged: (_) => _onTextChanged(),
              maxLines: null,
              minLines: 15,
              style: AppTypography.bodyLg,
              decoration: InputDecoration(
                hintText: 'Start writing...',
                hintStyle: AppTypography.bodyLg.copyWith(color: AppColors.outline),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
