import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/rating_stars.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class BookDetailHeader extends StatelessWidget {
  const BookDetailHeader({super.key, required this.book, required this.onRatingChanged});
  final BookItem book;
  final ValueChanged<double> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: SizedBox(
            width: 110,
            height: 165,
            child: book.coverUrl != null
                ? Image.network(book.coverUrl!, fit: BoxFit.cover)
                : const ColoredBox(
                    color: AppColors.surfaceContainerHigh,
                    child: Center(
                      child: Icon(Icons.book_outlined, size: 40, color: AppColors.outline),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: AppSpacing.stackGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.title, style: AppTypography.headlineLg, maxLines: 3),
              const SizedBox(height: 4),
              Text(book.author, style: AppTypography.bodyLgVariant()),
              const SizedBox(height: 8),
              RatingStars(
                rating: book.rating,
                starSize: 24,
                onRatingChanged: onRatingChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
