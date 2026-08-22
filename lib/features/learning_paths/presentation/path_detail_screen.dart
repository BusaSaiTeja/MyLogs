import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/learning_paths/application/learning_path_providers.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';
import 'package:my_logs/features/learning_paths/presentation/widgets/path_progress_card.dart';
import 'package:my_logs/features/learning_paths/presentation/widgets/path_step_tile.dart';

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
          PathProgressCard(
            completedCount: completedCount,
            totalCount: path.steps.length,
            progress: progress,
          ),
          const SizedBox(height: AppSpacing.groupGap),
          Text('Steps', style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.stackGap),
          ...sortedSteps.map((step) => PathStepTile(
                step: step,
                onToggle: () =>
                    ref.read(learningPathListProvider.notifier).toggleStep(pathId, step.id),
              )),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
