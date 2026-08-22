import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';

class MediaRatingSelector extends StatelessWidget {
  const MediaRatingSelector({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  final double? rating;
  final ValueChanged<double> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(10, (i) {
          final v = (i + 1).toDouble();
          return Expanded(
            child: Semantics(
              button: true,
              selected: rating == v,
              label: 'Rating ${i + 1} out of 10',
              child: GestureDetector(
                onTap: () => onRatingChanged(v),
                child: Container(
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: (rating ?? 0) >= v ? AppColors.primary : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: AppTypography.labelMd.copyWith(
                        color: (rating ?? 0) >= v ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        if (rating != null) ...[
          const SizedBox(width: 8),
          Text(rating!.toStringAsFixed(1), style: AppTypography.bodyLg),
        ],
      ],
    );
  }
}
