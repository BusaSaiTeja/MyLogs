import 'package:flutter/material.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_editor_dialog.dart';

/// Legacy alias for WorkspaceEditorDialog in first-workspace mode.
/// Retained for backward-compatibility while unifying all workspace forms (DRY / SSOT).
class CreateFirstWorkspaceDialog extends StatelessWidget {
  const CreateFirstWorkspaceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return WorkspaceEditorDialog.show(context, isFirstWorkspace: true);
  }

  @override
  Widget build(BuildContext context) {
    return const WorkspaceEditorDialog(isFirstWorkspace: true);
  }
}
