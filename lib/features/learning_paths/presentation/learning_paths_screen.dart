import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/features/learning_paths/application/learning_path_providers.dart';
import 'package:my_logs/features/learning_paths/presentation/widgets/learning_path_card.dart';

class LearningPathsScreen extends ConsumerWidget {
  const LearningPathsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathsAsync = ref.watch(learningPathListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text('Learning Paths',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppColors.primary,
            onPressed: () => context.push('/learning-paths/add'),
          ),
        ],
      ),
      body: pathsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (paths) => paths.isEmpty
            ? EmptyState(
                icon: Icons.school_outlined,
                title: 'No paths yet',
                subtitle: 'Create your first learning journey',
                actionLabel: 'New Path',
                onAction: () => context.push('/learning-paths/add'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                itemCount: paths.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.stackGap),
                itemBuilder: (context, i) {
                  final path = paths[i];
                  final progress = ref.watch(pathProgressProvider(path.id));
                  final status = ref.watch(pathStatusProvider(path.id));
                  return LearningPathCard(
                    path: path,
                    progress: progress,
                    status: status,
                    onTap: () => context.push('/learning-paths/${path.id}'),
                    onDelete: () => ref.read(learningPathListProvider.notifier).delete(path.id),
                  );
                },
              ),
      ),
    );
  }
}
