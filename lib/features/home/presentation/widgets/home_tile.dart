import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showDivider = false,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: AppColors.primary.withValues(alpha: 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.obsidian,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      subtitle!,
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.outline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showDivider)
              const Divider(
                color: Color(0xFFF1F5F9),
                height: 1,
                thickness: 1,
                indent: 48,
                endIndent: 16,
              ),
          ],
        ),
      ),
    );
  }
}
