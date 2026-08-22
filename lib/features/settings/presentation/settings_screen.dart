import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        title: Text('Settings',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          _SettingsSection(title: 'Account', tiles: [
            _SettingsTile(icon: Icons.person_outline_rounded, label: 'Profile', subtitle: 'Coming in Phase 2'),
            _SettingsTile(icon: Icons.security_outlined, label: 'Privacy & Security', subtitle: 'Coming in Phase 2'),
          ]),
          const SizedBox(height: AppSpacing.groupGap),
          _SettingsSection(title: 'Preferences', tiles: [
            _SettingsTile(icon: Icons.dark_mode_outlined, label: 'Theme', subtitle: 'System default'),
            _SettingsTile(icon: Icons.notifications_outlined, label: 'Notifications', subtitle: 'Manage local reminders'),
          ]),
          const SizedBox(height: AppSpacing.groupGap),
          _SettingsSection(title: 'Data', tiles: [
            _SettingsTile(icon: Icons.cloud_upload_outlined, label: 'Sync & Backup', subtitle: 'Cloud sync in Phase 2'),
            _SettingsTile(icon: Icons.import_export_rounded, label: 'Export Data', subtitle: 'Coming soon'),
          ]),
          const SizedBox(height: AppSpacing.groupGap),
          Center(
            child: Column(
              children: [
                Text('MyLog', style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('Version 1.0.0 — Phase 1 (Local)', style: AppTypography.bodyMdOutline()),
                const SizedBox(height: 4),
                Text('Firebase integration coming in Phase 2',
                    style: AppTypography.bodyMdOutline()),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.groupGap),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.tiles});
  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radius2Xl),
          ),
          child: Column(
            children: tiles.indexed.map((t) {
              final (i, tile) = t;
              return Column(
                children: [
                  tile,
                  if (i < tiles.length - 1)
                    const Divider(
                      height: 1,
                      indent: 56,
                      color: AppColors.surfaceContainerHighest,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.label, this.subtitle});
  final IconData icon;
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTypography.bodyLg),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTypography.bodyMdOutline())
          : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant, size: 20),
      onTap: () {},
    );
  }
}
