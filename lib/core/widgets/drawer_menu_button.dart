import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

/// Reusable leading drawer toggle button for app bars.
/// Eliminates duplicate drawer state toggling logic across screens (DRY / Rule of Three).
class DrawerMenuButton extends StatelessWidget {
  final String tooltip;
  final Color iconColor;

  const DrawerMenuButton({
    super.key,
    this.tooltip = 'Open menu',
    this.iconColor = AppColors.obsidian,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded),
      color: iconColor,
      tooltip: tooltip,
      onPressed: () {
        if (rootScaffoldKey.currentState?.isDrawerOpen == true) {
          rootScaffoldKey.currentState?.closeDrawer();
        } else {
          rootScaffoldKey.currentState?.openDrawer();
        }
      },
    );
  }
}
