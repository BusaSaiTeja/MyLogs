import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';

class FeatureDefinition {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FeatureDefinition({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const List<FeatureDefinition> availableAppFeatures = [
  FeatureDefinition(
    key: 'notes',
    title: 'Notes',
    description: 'Capture thoughts, lists & category tags',
    icon: Icons.description_outlined,
    color: Color(0xFF3B82F6),
  ),
  FeatureDefinition(
    key: 'tasks',
    title: 'Tasks',
    description: 'Track today & upcoming to-dos with priorities',
    icon: Icons.check_box_outlined,
    color: Color(0xFF10B981),
  ),
  FeatureDefinition(
    key: 'reminders',
    title: 'Reminders',
    description: 'Exact alarms, alerts & scheduled notifications',
    icon: Icons.alarm_rounded,
    color: Color(0xFFF59E0B),
  ),
  FeatureDefinition(
    key: 'read',
    title: 'Read Tracker',
    description: 'Track reading progress, Google Books & ratings',
    icon: Icons.menu_book_outlined,
    color: Color(0xFF8B5CF6),
  ),
  FeatureDefinition(
    key: 'watch',
    title: 'Watch Hub',
    description: 'Movies, anime & series tracking via TMDB & AniList',
    icon: Icons.movie_outlined,
    color: Color(0xFFEC4899),
  ),
  FeatureDefinition(
    key: 'learning_paths',
    title: 'Learning Paths',
    description: 'Create multi-step learning roadmaps with resources',
    icon: Icons.alt_route_rounded,
    color: Color(0xFF06B6D4),
  ),
];

class FeatureMarketplaceModal extends ConsumerWidget {
  const FeatureMarketplaceModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeatureMarketplaceModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWs = ref.watch(activeWorkspaceProvider);
    final enabledKeys = activeWs?.enabledFeatures ??
        ['notes', 'tasks', 'reminders', 'read', 'watch', 'learning_paths'];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.extension_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feature Marketplace',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Configure modules for "${activeWs?.name ?? 'Workspace'}"',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE2E8F0), height: 1),
            const SizedBox(height: 12),

            // Feature List
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: availableAppFeatures.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final feature = availableAppFeatures[index];
                  final isEnabled = enabledKeys.contains(feature.key);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? Colors.white
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      border: Border.all(
                        color: isEnabled
                            ? feature.color.withValues(alpha: 0.4)
                            : const Color(0xFFE2E8F0),
                        width: isEnabled ? 1.5 : 1,
                      ),
                      boxShadow: isEnabled
                          ? [
                              BoxShadow(
                                color: feature.color.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isEnabled
                                ? feature.color.withValues(alpha: 0.12)
                                : const Color(0xFFE2E8F0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            feature.icon,
                            color: isEnabled ? feature.color : AppColors.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature.title,
                                style: TextStyle(
                                  color: isEnabled ? AppColors.onSurface : AppColors.onSurfaceVariant,
                                  fontSize: 14,
                                  fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                feature.description,
                                style: TextStyle(
                                  color: isEnabled ? AppColors.onSurfaceVariant : AppColors.outline,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: isEnabled,
                          activeThumbColor: feature.color,
                          activeTrackColor: feature.color.withValues(alpha: 0.35),
                          onChanged: (val) {
                            if (activeWs != null) {
                              ref
                                  .read(workspaceListProvider.notifier)
                                  .toggleFeature(activeWs.id, feature.key);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
