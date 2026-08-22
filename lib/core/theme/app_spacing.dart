/// Spacing and border-radius constants from DESIGN.md.
abstract final class AppSpacing {
  // ── Base unit ─────────────────────────────────────────────────────────────
  static const double unit = 4.0;

  // ── Named spacing tokens ──────────────────────────────────────────────────
  static const double containerPadding = 24.0;
  static const double stackGap = 16.0;
  static const double groupGap = 32.0;
  static const double gutter = 16.0;
  static const double mobileSideMargin = 20.0;

  // ── Border radii ──────────────────────────────────────────────────────────
  /// 0.25rem = 4px
  static const double radiusSm = 4.0;

  /// 0.5rem = 8px (DEFAULT in DESIGN.md)
  static const double radiusMd = 8.0;

  /// 0.75rem = 12px (DESIGN.md "md")
  static const double radiusLg = 12.0;

  /// 1rem = 16px (DESIGN.md "lg" — interactive elements, buttons, inputs)
  static const double radiusXl = 16.0;

  /// 1.5rem = 24px (DESIGN.md "xl" — cards)
  static const double radius2Xl = 24.0;

  /// Fully circular pill
  static const double radiusFull = 9999.0;
}
