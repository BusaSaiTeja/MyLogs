import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';

/// Tappable star-rating row that supports half-star precision (0.5 increments).
/// Purely presentational — calls [onRatingChanged] on tap.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.starSize = 24.0,
    this.onRatingChanged,
    this.color = AppColors.starAmber,
    this.emptyColor = AppColors.outlineVariant,
  });

  final double? rating; // null = unrated
  final int maxStars;
  final double starSize;
  final ValueChanged<double>? onRatingChanged;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    final r = rating ?? 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        final starValue = i + 1.0;
        final halfValue = i + 0.5;
        IconData icon;
        Color iconColor;
        if (r >= starValue) {
          icon = Icons.star_rounded;
          iconColor = color;
        } else if (r >= halfValue) {
          icon = Icons.star_half_rounded;
          iconColor = color;
        } else {
          icon = Icons.star_outline_rounded;
          iconColor = emptyColor;
        }
        if (onRatingChanged != null) {
          return GestureDetector(
            onTapUp: (details) {
              // Tap left half → half star, right half → full star
              final box = context.findRenderObject() as RenderBox?;
              if (box == null) return;
              final localPos = box.globalToLocal(details.globalPosition);
              final cellWidth = box.size.width / maxStars;
              final tapX = localPos.dx - (i * cellWidth);
              final newRating = tapX < cellWidth / 2 ? halfValue : starValue;
              onRatingChanged!(newRating);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Icon(icon, color: iconColor, size: starSize),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Icon(icon, color: iconColor, size: starSize),
        );
      }),
    );
  }
}
