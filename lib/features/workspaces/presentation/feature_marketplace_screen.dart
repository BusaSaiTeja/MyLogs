import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/domain/models/feature_definition.dart';
import 'package:my_logs/features/workspaces/presentation/feature_preview_screen.dart';

class FeatureMarketplaceScreen extends ConsumerStatefulWidget {
  const FeatureMarketplaceScreen({super.key});

  @override
  ConsumerState<FeatureMarketplaceScreen> createState() => _FeatureMarketplaceScreenState();
}

class _FeatureMarketplaceScreenState extends ConsumerState<FeatureMarketplaceScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Productivity',
    'Entertainment',
    'Knowledge & Culture',
  ];

  @override
  Widget build(BuildContext context) {
    final activeWs = ref.watch(activeWorkspaceProvider);
    final enabledKeys = activeWs?.enabledFeatures ??
        ['notes', 'tasks', 'reminders', 'read', 'watch', 'learning_paths'];

    // Only show features that are NOT yet enabled in the active workspace
    final uninstalledFeatures = availableAppFeatures
        .where((f) => !enabledKeys.contains(f.key))
        .toList();

    final filteredFeatures = _selectedCategory == 'All'
        ? uninstalledFeatures
        : uninstalledFeatures
            .where((f) => f.category == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.obsidian,
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Feature Marketplace',
          style: AppTypography.headlineLgMobile.copyWith(color: AppColors.obsidian),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // ── Category Filter Pills ──────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    backgroundColor: AppColors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14.0),

          // ── Empty State if all features are installed ─────────────────────
          if (filteredFeatures.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.done_all_rounded,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'All Caught Up!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedCategory == 'All'
                          ? 'All available features are already enabled in ${activeWs?.name ?? 'your workspace'}.'
                          : 'All $_selectedCategory features are already enabled.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Feature Cards ──────────────────────────────────────────────────
          ...filteredFeatures.map((feature) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Icon + Title + Category
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: feature.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(feature.icon, color: feature.color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              feature.category,
                              style: TextStyle(
                                fontSize: 11,
                                color: feature.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Text(
                    feature.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 12),

                  // Bottom Action Buttons: [ 👁️ Preview ] and [ + Add Feature ]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Preview Button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FeaturePreviewScreen(feature: feature),
                            ),
                          );
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                        label: const Text(
                          'Preview',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Add Feature Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: feature.color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (activeWs != null) {
                            ref
                                .read(workspaceListProvider.notifier)
                                .toggleFeature(activeWs.id, feature.key);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added ${feature.title} to ${activeWs.name}!',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text(
                          'Add Feature',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
