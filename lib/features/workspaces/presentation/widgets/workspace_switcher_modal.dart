import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/domain/models/workspace_item.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_editor_dialog.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_icons.dart';

class WorkspaceSwitcherModal extends ConsumerWidget {
  const WorkspaceSwitcherModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WorkspaceSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaces = ref.watch(workspaceListProvider).valueOrNull ?? [];
    final activeId = ref.watch(activeWorkspaceIdProvider).valueOrNull;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag Handle ───────────────────────────────────────────────
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header ────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Workspaces', style: AppTypography.headlineMd),
                      const SizedBox(height: 2),
                      Text(
                        'Switch between projects & contexts',
                        style: AppTypography.bodyMdOutline().copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      context.pop();
                      WorkspaceEditorDialog.show(context);
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Workspace Items List ──────────────────────────────────────
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: workspaces.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final ws = workspaces[index];
                    final isActive = ws.id == activeId || (activeId == null && index == 0);
                    final icon = WorkspaceThemeData.getIcon(ws.iconName);
                    final color = Color(ws.colorValue);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ref.read(activeWorkspaceIdProvider.notifier).setActive(ws.id);
                          context.pop();
                        },
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? color.withValues(alpha: 0.1)
                                : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                            border: Border.all(
                              color: isActive ? color.withValues(alpha: 0.4) : AppColors.surfaceContainerHighest,
                              width: isActive ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(icon, color: color, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ws.name,
                                      style: AppTypography.bodyLg.copyWith(
                                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                        color: isActive ? color : AppColors.onSurface,
                                      ),
                                    ),
                                    if (ws.isDefault)
                                      Text(
                                        'Default Workspace',
                                        style: AppTypography.labelMdOutline().copyWith(fontSize: 11),
                                      ),
                                  ],
                                ),
                              ),
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                color: AppColors.outline,
                                visualDensity: VisualDensity.compact,
                                onPressed: () => WorkspaceEditorDialog.show(context, workspace: ws),
                              ),
                              if (!ws.isDefault && workspaces.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                  color: AppColors.outline,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => _confirmDelete(context, ref, ws),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static void _confirmDelete(BuildContext context, WidgetRef ref, WorkspaceItem ws) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radius2Xl)),
        title: Text('Delete "${ws.name}"?'),
        content: const Text(
          'This workspace will be removed. Your logs will remain accessible under other workspaces.',
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref.read(workspaceListProvider.notifier).deleteWorkspace(ws.id);
              ctx.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

}

