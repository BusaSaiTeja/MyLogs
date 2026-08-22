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
        padding: const EdgeInsets.all(AppSpacing.groupGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: AppSpacing.stackGap),
            Text(
              title,
              style: AppTypography.headlineMd.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.unit * 2),
              Text(
                subtitle!,
                style: AppTypography.bodyMdVariant(),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.groupGap),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding,
                    vertical: 12,
                  ),
                ),
                child: Text(actionLabel!, style: AppTypography.labelMdPrimary().copyWith(color: AppColors.onPrimary)),
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
