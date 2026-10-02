import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_logs/core/theme/app_colors.dart';

/// Typography definitions matching DESIGN.md exactly.
/// All styles use Inter via google_fonts.
abstract final class AppTypography {
  // ── Display: 32sp / 700 / tight tracking ──────────────────────────────────
  static TextStyle get display => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.8,
        color: AppColors.obsidian,
      );

  // ── Headline LG: 24sp / 700 / tight tracking ──────────────────────────────
  static TextStyle get headlineLg => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.5,
        color: AppColors.obsidian,
      );

  // ── Headline LG Mobile: 22sp / 700 ────────────────────────────────────────
  static TextStyle get headlineLgMobile => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 28 / 22,
        letterSpacing: -0.4,
        color: AppColors.obsidian,
      );

  // ── Headline MD: 19sp / 600 ───────────────────────────────────────────────
  static TextStyle get headlineMd => GoogleFonts.outfit(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 26 / 19,
        letterSpacing: -0.3,
        color: AppColors.obsidian,
      );

  // ── Body LG: 16sp / 400 ───────────────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  // ── Body MD: 14sp / 400 ───────────────────────────────────────────────────
  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.onSurface,
      );

  // ── Label MD: 12sp / 600 ──────────────────────────────────────────────────
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.2,
        color: AppColors.onSurface,
      );

  // ── Eyebrow / Section Tag: 11sp / 700 / loose tracking (0.08em) ───────────
  static TextStyle get labelEyebrow => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: AppColors.onSurfaceVariant,
      );

  // ── Convenience: coloured variants ───────────────────────────────────────
  static TextStyle bodyMdVariant() =>
      bodyMd.copyWith(color: AppColors.onSurfaceVariant);
  static TextStyle bodyLgVariant() =>
      bodyLg.copyWith(color: AppColors.onSurfaceVariant);
  static TextStyle labelMdVariant() =>
      labelMd.copyWith(color: AppColors.onSurfaceVariant);
  static TextStyle labelMdOutline() =>
      labelMd.copyWith(color: AppColors.outline);
  static TextStyle bodyMdOutline() =>
      bodyMd.copyWith(color: AppColors.outline);
  static TextStyle headlineMdVariant() =>
      headlineMd.copyWith(color: AppColors.onSurfaceVariant);
  static TextStyle bodyLgPrimary() =>
      bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600);
  static TextStyle labelMdPrimary() =>
      labelMd.copyWith(color: AppColors.primary);
  static TextStyle headlineLgPrimary() =>
      headlineLg.copyWith(color: AppColors.primary);
}
