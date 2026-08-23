import 'package:flutter/material.dart';

/// All color tokens from DESIGN.md — single source of truth.
/// Naming matches the design system's CSS custom-property names (camelCase).
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3525CD);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color onPrimaryContainer = Color(0xFFDAD7FF);
  static const Color inversePrimary = Color(0xFFC3C0FF);

  // ── Primary Fixed ─────────────────────────────────────────────────────────
  static const Color primaryFixed = Color(0xFFE2DFFF);
  static const Color primaryFixedDim = Color(0xFFC3C0FF);
  static const Color onPrimaryFixed = Color(0xFF0F0069);
  static const Color onPrimaryFixedVariant = Color(0xFF3323CC);

  // ── Secondary ─────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF4648D4);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF6063EE);
  static const Color onSecondaryContainer = Color(0xFFFFFFFF);

  // ── Secondary Fixed ───────────────────────────────────────────────────────
  static const Color secondaryFixed = Color(0xFFE1E0FF);
  static const Color secondaryFixedDim = Color(0xFFC0C1FF);
  static const Color onSecondaryFixed = Color(0xFF07006C);
  static const Color onSecondaryFixedVariant = Color(0xFF2F2EBE);

  // ── Tertiary ──────────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF7E3000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFA44100);
  static const Color onTertiaryContainer = Color(0xFFFFD2BE);
  static const Color tertiaryFixed = Color(0xFFFFDBCC);
  static const Color tertiaryFixedDim = Color(0xFFFFB695);
  static const Color onTertiaryFixed = Color(0xFF351000);
  static const Color onTertiaryFixedVariant = Color(0xFF7B2F00);

  // ── Surface ───────────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceDim = Color(0xFFD8DADC);
  static const Color surfaceBright = Color(0xFFF7F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  static const Color surfaceVariant = Color(0xFFE0E3E5);
  static const Color surfaceTint = Color(0xFF4D44E3);

  // ── On-Surface ────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF464555);
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F3);

  // ── Outline ───────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF777587);
  static const Color outlineVariant = Color(0xFFC7C4D8);

  // ── Background ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F9FB);
  static const Color onBackground = Color(0xFF191C1E);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Semantic helpers (mapping DESIGN.md intent) ───────────────────────────
  /// Amber for star ratings
  static const Color starAmber = Color(0xFFF59E0B);

  /// Status chip backgrounds (low-saturation tints)
  static const Color statusWatching = Color(0xFFDCFCE7);   // pale green
  static const Color statusCompleted = Color(0xFFDBEAFE);  // pale blue
  static const Color statusOnHold = Color(0xFFFEF9C3);     // pale yellow
  static const Color statusDropped = Color(0xFFFFE4E6);    // pale red
  static const Color statusPlanTo = Color(0xFFF3E8FF);     // pale purple

  static const Color statusWatchingText = Color(0xFF166534);
  static const Color statusCompletedText = Color(0xFF1E40AF);
  static const Color statusOnHoldText = Color(0xFF854D0E);
  static const Color statusDroppedText = Color(0xFF9F1239);
  static const Color statusPlanToText = Color(0xFF6B21A8);

  // Priority dot colors (tasks)
  static const Color priorityHigh = error;
  static const Color priorityMedium = secondaryContainer;
  static const Color priorityLow = tertiaryContainer;

  // ── Card Elevation / Shadows ──────────────────────────────────────────────
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
}
