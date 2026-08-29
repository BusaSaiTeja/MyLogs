import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/rating_stars.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.onDelete,
  });

  final BookItem book;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final cardChild = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.stackGap),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cover thumbnail ────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: SizedBox(
                width: 80,
                height: 120,
                child: book.coverUrl != null
                    ? CachedNetworkImage(
                        imageUrl: book.coverUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const _BookCoverPlaceholder(),
                        errorWidget: (_, _, _) => const _BookCoverPlaceholder(),
                      )
                    : const _BookCoverPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.gutter),

            // ── Title, author, rating, pages, genres ───────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    book.title,
                    style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    style: AppTypography.bodyMdVariant(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Rating stars + pages on same row
                  Row(
                    children: [
                      RatingStars(
                        rating: book.rating,
                        starSize: 16,
                        onRatingChanged: null,
                      ),
                      if (book.totalPages != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.menu_book_outlined, size: 12, color: AppColors.outline),
                        const SizedBox(width: 3),
                        Text('${book.totalPages} pages', style: AppTypography.labelMdOutline()),
                      ],
                    ],
                  ),
                  if (book.genres.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: book.genres.take(2).map((g) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          g,
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return cardChild;
  }
}

class _BookCoverPlaceholder extends StatelessWidget {
  const _BookCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceContainerHigh,
      child: Center(
        child: Icon(Icons.book_outlined, color: AppColors.outline, size: 28),
      ),
    );
  }
}
