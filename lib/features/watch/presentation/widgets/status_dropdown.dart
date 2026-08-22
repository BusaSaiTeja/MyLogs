import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

class MediaStatusDropdown extends StatelessWidget {
  const MediaStatusDropdown({super.key, required this.value, required this.onChanged});
  final MediaStatus value;
  final ValueChanged<MediaStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MediaStatus>(
          value: value,
          onChanged: onChanged,
          isDense: true,
          style: AppTypography.bodyMd,
          items: MediaStatus.values
              .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
              .toList(),
        ),
      ),
    );
  }
}
