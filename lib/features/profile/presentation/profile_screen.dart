import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Profile',
          style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.primary,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          // ── User Header Card ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.groupGap),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(Icons.person_rounded, size: 36, color: AppColors.onPrimaryContainer),
                ),
                const SizedBox(width: AppSpacing.stackGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Personal Tracker', style: AppTypography.headlineMd),
                      const SizedBox(height: 4),
                      Text('Local Mode — Phase 1', style: AppTypography.bodyMdOutline()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.groupGap),

          // ── Quick Options / Settings Tile ──────────────────────────────────
          Text('Account & Preferences', style: AppTypography.labelMdVariant()),
          const SizedBox(height: AppSpacing.unit * 2),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
                  title: Text('Settings', style: AppTypography.bodyLg),
                  subtitle: Text('App preferences, theme, & data options', style: AppTypography.bodyMdOutline()),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant),
                  onTap: () => context.push('/settings'),
                ),
                const Divider(height: 1, indent: 56, color: AppColors.surfaceContainerHighest),
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                  title: Text('Edit Profile', style: AppTypography.bodyLg),
                  subtitle: Text('Sync profile in Phase 2', style: AppTypography.bodyMdOutline()),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, color: AppColors.surfaceContainerHighest),
                ListTile(
                  leading: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                  title: Text('Cloud Backup', style: AppTypography.bodyLg),
                  subtitle: Text('Firebase Cloud Sync coming in Phase 2', style: AppTypography.bodyMdOutline()),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.groupGap),

          Center(
            child: Text(
              'MyLog v1.0.0 — Phase 1',
              style: AppTypography.bodyMdOutline(),
            ),
          ),
        ],
      ),
    );
  }
}
