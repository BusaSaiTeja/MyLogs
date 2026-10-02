import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

/// Shown when a list is empty — an icon, title, and optional action button.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(icon, size: 28, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.obsidian,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  subtitle!,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Simple loading overlay that wraps Riverpod AsyncValue states.
class AsyncStateHandler<T> extends StatelessWidget {
  const AsyncStateHandler({
    super.key,
    required this.asyncValue,
    required this.data,
    this.loadingWidget,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) data;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      loading: () =>
          loadingWidget ??
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.stackGap),
              Text('Something went wrong', style: AppTypography.headlineMd),
              const SizedBox(height: AppSpacing.unit * 2),
              Text(e.toString(), style: AppTypography.bodyMdVariant(), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      data: data,
    );
  }
}
