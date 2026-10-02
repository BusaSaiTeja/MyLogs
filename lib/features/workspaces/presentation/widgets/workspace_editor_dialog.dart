import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/domain/models/workspace_item.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_icons.dart';

/// Single unified dialog for creating, editing, and onboarding workspaces.
/// Unifies CreateFirstWorkspaceDialog, _showCreateWorkspaceDialog, and _showEditWorkspaceDialog (DRY / SSOT).
class WorkspaceEditorDialog extends ConsumerStatefulWidget {
  final WorkspaceItem? initialWorkspace;
  final bool isFirstWorkspace;

  const WorkspaceEditorDialog({
    super.key,
    this.initialWorkspace,
    this.isFirstWorkspace = false,
  });

  static Future<void> show(
    BuildContext context, {
    WorkspaceItem? workspace,
    bool isFirstWorkspace = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: !isFirstWorkspace,
      builder: (_) => WorkspaceEditorDialog(
        initialWorkspace: workspace,
        isFirstWorkspace: isFirstWorkspace,
      ),
    );
  }

  @override
  ConsumerState<WorkspaceEditorDialog> createState() => _WorkspaceEditorDialogState();
}

class _WorkspaceEditorDialogState extends ConsumerState<WorkspaceEditorDialog> {
  late final TextEditingController _nameCtrl;
  late String _selectedIcon;
  late int _selectedColor;
  bool _isSaving = false;

  bool get _isEditMode => widget.initialWorkspace != null;

  @override
  void initState() {
    super.initState();
    final ws = widget.initialWorkspace;
    if (ws != null) {
      _nameCtrl = TextEditingController(text: ws.name);
      _selectedIcon = ws.iconName;
      _selectedColor = ws.colorValue;
    } else if (widget.isFirstWorkspace) {
      _nameCtrl = TextEditingController(text: 'Personal');
      _selectedIcon = 'person_outline_rounded';
      _selectedColor = 0xFF4F46E5;
    } else {
      _nameCtrl = TextEditingController();
      _selectedIcon = 'folder_outlined';
      _selectedColor = WorkspaceThemeData.availableColors.first;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      if (_isEditMode) {
        final current = widget.initialWorkspace!;
        await ref.read(workspaceListProvider.notifier).updateWorkspace(
              current.copyWith(
                name: name,
                iconName: _selectedIcon,
                colorValue: _selectedColor,
              ),
            );
      } else {
        await ref.read(workspaceListProvider.notifier).addWorkspace(
              name: name,
              iconName: _selectedIcon,
              colorValue: _selectedColor,
            );
      }
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditMode
        ? 'Edit Workspace'
        : (widget.isFirstWorkspace ? 'Create Workspace' : 'New Workspace');
    final subtitle = widget.isFirstWorkspace
        ? 'Organize your logs & tasks'
        : (_isEditMode ? 'Update workspace identity' : 'Create a dedicated workspace');
    final buttonLabel = _isEditMode
        ? 'Save Changes'
        : (widget.isFirstWorkspace ? 'Get Started' : 'Create');

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radius2Xl)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(_selectedColor).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isEditMode ? Icons.edit_rounded : Icons.dashboard_customize_rounded,
                color: Color(_selectedColor),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.headlineMd),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMdOutline().copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                autofocus: !_isEditMode && !widget.isFirstWorkspace,
                decoration: InputDecoration(
                  labelText: 'Workspace Name',
                  hintText: 'e.g. Personal, Work, College',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                ),
              ),
              const SizedBox(height: 18),
              Text('Select Icon', style: AppTypography.labelMdVariant()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WorkspaceThemeData.availableIcons.entries.map((entry) {
                  final isSel = _selectedIcon == entry.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = entry.key),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSel
                            ? Color(_selectedColor).withValues(alpha: 0.15)
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSel ? Color(_selectedColor) : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        entry.value,
                        color: isSel ? Color(_selectedColor) : AppColors.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              Text('Color Theme', style: AppTypography.labelMdVariant()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WorkspaceThemeData.availableColors.map((colorVal) {
                  final isSel = _selectedColor == colorVal;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = colorVal),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color(colorVal),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSel ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSel
                            ? [BoxShadow(color: Color(colorVal).withValues(alpha: 0.5), blurRadius: 6)]
                            : null,
                      ),
                      child: isSel
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          if (!widget.isFirstWorkspace)
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(_selectedColor),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
