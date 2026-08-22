import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/features/learning_paths/application/learning_path_providers.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';

class PathDetailScreen extends ConsumerWidget {
  const PathDetailScreen({super.key, required this.pathId});
  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(learningPathByIdProvider(pathId));
    final progress = ref.watch(pathProgressProvider(pathId));

    if (path == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Path not found')),
      );
    }

    final sortedSteps = List<PathStep>.from(path.steps)..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    final completedCount = sortedSteps.where((s) => s.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Learning Path',
          style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppColors.primary,
            onPressed: () => context.push('/learning-paths/$pathId/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          Text(path.title, style: AppTypography.display),
          if (path.description != null) ...[
            const SizedBox(height: 8),
            Text(path.description!, style: AppTypography.bodyLgVariant()),
          ],
          const SizedBox(height: AppSpacing.groupGap),
          // Progress overview
          Container(
            padding: const EdgeInsets.all(AppSpacing.stackGap),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(color: AppColors.surfaceContainerHighest),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('$completedCount / ${path.steps.length} steps',
                        style: AppTypography.headlineMd),
                    const Spacer(),
                    Text('${(progress * 100).round()}%',
                        style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 10),
                AppProgressBar(progress: progress, height: 10),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.groupGap),
          Text('Steps', style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.stackGap),
          ...sortedSteps.asMap().entries.map((e) {
            final step = e.value;
            return _StepTile(
              step: step,
              onToggle: () =>
                  ref.read(learningPathListProvider.notifier).toggleStep(pathId, step.id),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step, required this.onToggle});
  final PathStep step;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
      padding: const EdgeInsets.all(AppSpacing.stackGap),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: step.isCompleted ? AppColors.primary.withValues(alpha: 0.3) : AppColors.surfaceContainerHighest,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number / check circle
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.isCompleted ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: step.isCompleted ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
              ),
              child: step.isCompleted
                  ? const Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 16)
                  : Center(
                      child: Text(
                        '${step.order}',
                        style: AppTypography.labelMd.copyWith(color: AppColors.outline),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.stackGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: step.isCompleted
                      ? AppTypography.bodyLg.copyWith(
                          color: AppColors.outline,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.outline,
                        )
                      : AppTypography.bodyLg,
                ),
                if (step.description != null) ...[
                  const SizedBox(height: 4),
                  Text(step.description!, style: AppTypography.bodyMdVariant()),
                ],
                if (step.resourceUrl != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.link_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          step.resourceUrl!,
                          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
