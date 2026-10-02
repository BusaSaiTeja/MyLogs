import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_icons.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_switcher_modal.dart';

class WorkspaceAppBarButton extends ConsumerWidget {
  const WorkspaceAppBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWs = ref.watch(activeWorkspaceProvider);
    final iconName = activeWs?.iconName ?? 'person_outline_rounded';
    final color = Color(activeWs?.colorValue ?? 0xFF4F46E5);
    final icon = WorkspaceThemeData.getIcon(iconName);

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: InkWell(
        onTap: () {
          if (rootScaffoldKey.currentState?.isDrawerOpen == true) {
            rootScaffoldKey.currentState?.closeDrawer();
          } else if (rootScaffoldKey.currentState != null) {
            rootScaffoldKey.currentState?.openDrawer();
          } else {
            WorkspaceSwitcherModal.show(context);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              if (activeWs != null) ...[
                const SizedBox(width: 5),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    activeWs.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(width: 2),
              Icon(Icons.unfold_more_rounded, size: 14, color: color.withValues(alpha: 0.8)),
            ],
          ),
        ),
      ),
    );
  }
}
