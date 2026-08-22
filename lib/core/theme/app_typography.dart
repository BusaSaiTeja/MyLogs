import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_logs/core/theme/app_colors.dart';

/// Typography definitions matching DESIGN.md exactly.
/// All styles use Inter via google_fonts.
abstract final class AppTypography {
  // ── Display: 32sp / 700 / -0.02em ─────────────────────────────────────────
  static TextStyle get display => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: 32 * -0.02,
        color: AppColors.onSurface,
      );

  // ── Headline LG: 24sp / 600 / -0.01em ────────────────────────────────────
  static TextStyle get headlineLg => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: 24 * -0.01,
        color: AppColors.onSurface,
      );

  // ── Headline LG Mobile: 22sp / 600 ───────────────────────────────────────
  static TextStyle get headlineLgMobile => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        color: AppColors.onSurface,
      );

  // ── Headline MD: 20sp / 600 ───────────────────────────────────────────────
  static TextStyle get headlineMd => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.onSurface,
      );

  // ── Body LG: 16sp / 400 ──────────────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  // ── Body MD: 14sp / 400 ──────────────────────────────────────────────────
  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.onSurface,
      );

  // ── Label MD: 12sp / 600 / 0.05em ────────────────────────────────────────
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 12 * 0.05,
        color: AppColors.onSurface,
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
