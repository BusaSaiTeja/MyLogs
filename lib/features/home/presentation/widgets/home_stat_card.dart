import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

/// Bento hero and micro stat card with Outfit numerals and tactile ink ripple.
class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.eyebrow,
    this.isHero = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? eyebrow;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isHero ? 16 : 12,
            vertical: isHero ? 14 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(
              color: isHero
                  ? color.withValues(alpha: 0.25)
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isHero
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(icon, size: 20, color: color),
                          ),
                        ),
                        if (eyebrow != null)
                          Text(
                            eyebrow!.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: color,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: AppColors.obsidian,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          label,
                          style: AppTypography.bodyMdVariant().copyWith(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(icon, size: 18, color: color),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            value,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: AppColors.obsidian,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: AppTypography.bodyMdVariant().copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
