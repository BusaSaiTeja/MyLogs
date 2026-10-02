import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_icons.dart';

class CreateFirstWorkspaceDialog extends ConsumerStatefulWidget {
  const CreateFirstWorkspaceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CreateFirstWorkspaceDialog(),
    );
  }

  @override
  ConsumerState<CreateFirstWorkspaceDialog> createState() => _CreateFirstWorkspaceDialogState();
}

class _CreateFirstWorkspaceDialogState extends ConsumerState<CreateFirstWorkspaceDialog> {
  final _nameCtrl = TextEditingController(text: 'Personal');
  String _selectedIcon = 'person_outline_rounded';
  int _selectedColor = 0xFF4F46E5;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreating = true);

    try {
      await ref.read(workspaceListProvider.notifier).addWorkspace(
            name: name,
            iconName: _selectedIcon,
            colorValue: _selectedColor,
          );
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Icon(Icons.dashboard_customize_rounded, color: Color(_selectedColor), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Workspace', style: AppTypography.headlineMd),
                  Text(
                    'Organize your logs & tasks',
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
                        color: isSel ? Color(_selectedColor).withValues(alpha: 0.15) : AppColors.surfaceContainerLow,
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
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(_selectedColor),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isCreating ? null : _create,
              child: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Get Started', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
