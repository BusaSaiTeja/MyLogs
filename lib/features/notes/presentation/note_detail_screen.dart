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
  late TextEditingController _tagsCtrl;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
    _tagsCtrl = TextEditingController();

    if (!widget.isNew && widget.noteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final note = ref.read(noteByIdProvider(widget.noteId!));
        if (note == null) return;
        _titleCtrl.text = note.title;
        _contentCtrl.text = note.content;
        _tagsCtrl.text = note.tags.join(', ');
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }
    final tags = _tagsCtrl.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    final now = DateTime.now();

    if (widget.isNew) {
      await ref.read(noteListProvider.notifier).add(NoteItem(
            id: '',
            title: title,
            content: _contentCtrl.text,
            tags: tags,
            createdAt: now,
            updatedAt: now,
          ));
    } else {
      final existing = ref.read(noteByIdProvider(widget.noteId!));
      if (existing == null) return;
      await ref.read(noteListProvider.notifier).updateItem(existing.copyWith(
            title: title,
            content: _contentCtrl.text,
            tags: tags,
            updatedAt: now,
          ));
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.onSurfaceVariant,
          onPressed: () async {
            if (_hasChanges) {
              final discard = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Unsaved changes'),
                  content: const Text('Discard changes?'),
                  actions: [
                    TextButton(onPressed: () => ctx.pop(false), child: const Text('Keep editing')),
                    TextButton(
                        onPressed: () => ctx.pop(true),
                        child: const Text('Discard')),
                  ],
                ),
              );
              if (discard != true) return;
            }
            if (context.mounted) context.go('/');
          },
        ),
        title: Text(widget.isNew ? 'New Note' : 'Edit Note',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: AppTypography.labelMdPrimary()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          TextField(
            controller: _titleCtrl,
            onChanged: (_) => setState(() => _hasChanges = true),
            style: AppTypography.headlineLg.copyWith(fontSize: 22),
            decoration: InputDecoration(
              hintText: 'Note title',
              hintStyle: AppTypography.headlineLg.copyWith(fontSize: 22, color: AppColors.outline),
              border: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: AppSpacing.stackGap),
          TextField(
            controller: _contentCtrl,
            onChanged: (_) => setState(() => _hasChanges = true),
            maxLines: null,
            minLines: 15,
            style: AppTypography.bodyLg,
            decoration: InputDecoration(
              hintText: 'Start writing...',
              hintStyle: AppTypography.bodyLg.copyWith(color: AppColors.outline),
              border: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: AppSpacing.groupGap),
          Text('Tags (comma-separated)', style: AppTypography.labelMdVariant()),
          const SizedBox(height: 6),
          TextField(
            controller: _tagsCtrl,
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: const InputDecoration(hintText: 'design, work, personal'),
            style: AppTypography.bodyMd,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
