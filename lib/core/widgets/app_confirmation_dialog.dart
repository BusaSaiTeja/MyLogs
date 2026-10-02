import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/core/theme/app_colors.dart';

/// Centralized confirmation dialog for actions across the app.
///
/// Follows DRY and Single Source of Truth principles, enforcing consistent
/// typography, compact padding, and destruction styling.
Future<bool?> showAppConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  IconData? icon,
  Color confirmColor = const Color(0xFFDC2626),
  bool isDestructive = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogCtx) => AlertDialog(
      backgroundColor: AppColors.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: confirmColor, size: 22),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.obsidian,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 4),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: Text(
            cancelLabel,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: confirmColor,
          ),
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          child: Text(
            confirmLabel,
            style: TextStyle(
              color: confirmColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Centralized log out / sign out confirmation dialog.
Future<void> showLogoutConfirmationDialog({
  required BuildContext context,
  required WidgetRef ref,
  VoidCallback? onBeforeSignOut,
}) async {
  final confirmed = await showAppConfirmationDialog(
    context: context,
    title: 'Log Out',
    icon: Icons.logout_rounded,
    message: 'Are you sure you want to log out of your account?',
    confirmLabel: 'Log Out',
    confirmColor: const Color(0xFFDC2626),
    isDestructive: true,
  );

  if (confirmed == true) {
    onBeforeSignOut?.call();
    await ref.read(authServiceProvider).signOut();
  }
}
