import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/learning_paths/application/learning_path_providers.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';

class PathFormScreen extends ConsumerStatefulWidget {
  const PathFormScreen({super.key, this.pathId});
  final String? pathId;

  @override
  ConsumerState<PathFormScreen> createState() => _PathFormScreenState();
}

class _PathFormScreenState extends ConsumerState<PathFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  final List<_StepInput> _steps = [];

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    final pathId = widget.pathId;
    if (pathId != null) {
      _isEdit = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final path = ref.read(learningPathByIdProvider(pathId));
        if (path == null) return;
        _titleCtrl.text = path.title;
        _descCtrl.text = path.description ?? '';
        setState(() {
          for (final s in _steps) {
            s.title.dispose();
            s.resourceUrl.dispose();
          }
          _steps.clear();
          final sorted = List<PathStep>.from(path.steps)
            ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
          for (final s in sorted) {
            _steps.add(_StepInput(
              title: TextEditingController(text: s.title),
              resourceUrl: TextEditingController(text: s.resourceUrl ?? ''),
              id: s.id,
            ));
          }
        });
      });
    } else {
      _steps.add(_StepInput(
          title: TextEditingController(), resourceUrl: TextEditingController()));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    for (final s in _steps) {
      s.title.dispose();
      s.resourceUrl.dispose();
    }
    super.dispose();
  }

  void _removeStep(int i) {
    if (_steps.length > 1) {
      setState(() {
        final removed = _steps.removeAt(i);
        removed.title.dispose();
        removed.resourceUrl.dispose();
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final now = DateTime.now();
      final steps = _steps
          .asMap()
          .entries
          .where((e) => e.value.title.text.trim().isNotEmpty)
          .map((e) => PathStep(
                id: e.value.id ?? 'step-new-${e.key}',
                order: e.key + 1,
                title: e.value.title.text.trim(),
                resourceUrl: e.value.resourceUrl.text.trim().isEmpty
                    ? null
                    : e.value.resourceUrl.text.trim(),
                isCompleted: false,
              ))
          .toList();

      final pathId = widget.pathId;
      if (_isEdit && pathId != null) {
        final existing = ref.read(learningPathByIdProvider(pathId));
        if (existing == null) return;
        final updatedSteps = steps.map((s) {
          final orig = existing.steps.where((o) => o.id == s.id).firstOrNull;
          return s.copyWith(isCompleted: orig?.isCompleted ?? false);
        }).toList();
        await ref.read(learningPathListProvider.notifier).updateItem(existing.copyWith(
              title: _titleCtrl.text.trim(),
              description:
                  _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
              steps: updatedSteps,
              updatedAt: now,
            ));
      } else {
        final activeWorkspaceId = ref.read(activeWorkspaceIdProvider).valueOrNull ?? '';
        await ref.read(learningPathListProvider.notifier).add(LearningPath(
              id: '',
              workspaceId: activeWorkspaceId,
              title: _titleCtrl.text.trim(),
              description:
                  _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
              steps: steps,
              createdAt: now,
              updatedAt: now,
            ));
      }
      if (!mounted) return;
      router.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to save learning path: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.canPop() ? context.pop() : context.go('/learning-paths'),
        ),
        title: Text(_isEdit ? 'Edit Path' : 'New Learning Path',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          TextButton(onPressed: _save, child: Text('Save', style: AppTypography.labelMdPrimary())),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'path_form_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () {
          setState(() {
            _steps.add(_StepInput(
              title: TextEditingController(),
              resourceUrl: TextEditingController(),
            ));
          });
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Step'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            Text('Path Title *', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleCtrl,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: 'e.g. Advanced Flutter Development'),
              style: AppTypography.bodyLg,
            ),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Description', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'What will you learn?'),
              style: AppTypography.bodyLg,
            ),
            const SizedBox(height: AppSpacing.groupGap),
            Text('Steps (${_steps.length})', style: AppTypography.headlineMd),
            const SizedBox(height: AppSpacing.stackGap),
            ...List.generate(_steps.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.stackGap),
                padding: const EdgeInsets.all(AppSpacing.stackGap),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(color: AppColors.surfaceContainerHighest),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('${i + 1}',
                                style: AppTypography.labelMd.copyWith(color: AppColors.onPrimary, fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _steps[i].title,
                            decoration: const InputDecoration(hintText: 'Step title'),
                            style: AppTypography.bodyLg,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error),
                          onPressed: _steps.length > 1 ? () => _removeStep(i) : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _steps[i].resourceUrl,
                      decoration: const InputDecoration(hintText: 'Resource URL (optional)'),
                      style: AppTypography.bodyMd,
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _StepInput {
  _StepInput({required this.title, required this.resourceUrl, this.id});
  final TextEditingController title;
  final TextEditingController resourceUrl;
  final String? id;
}
