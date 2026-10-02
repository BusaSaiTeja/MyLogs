import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';

/// Reusable popup menu button for feature app bars.
/// Eliminates duplicate popup menus across feature screens (DRY / Rule of Three).
class FeatureMoreOptionsButton extends StatelessWidget {
  final String featureName;
  final VoidCallback? onSettingsTap;

  const FeatureMoreOptionsButton({
    super.key,
    required this.featureName,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurfaceVariant),
      tooltip: 'More options',
      onSelected: (value) {
        if (value == 'settings' && onSettingsTap != null) {
          onSettingsTap!();
        } else if (value == 'disable' || value == 'hide') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value == 'disable'
                    ? 'Disable $featureName (Coming in Phase 3)'
                    : 'Hide $featureName (Coming in Phase 3)',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'disable',
          child: Row(
            children: [
              Icon(Icons.pause_circle_outline_rounded, size: 18, color: AppColors.onSurfaceVariant),
              SizedBox(width: 8),
              Text('Disable feature'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'hide',
          child: Row(
            children: [
              Icon(Icons.visibility_off_outlined, size: 18, color: AppColors.onSurfaceVariant),
              SizedBox(width: 8),
              Text('Hide feature'),
            ],
          ),
        ),
      ],
    );
  }
}
