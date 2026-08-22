import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/status_chip.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.onTap});
  final BookItem book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = book.totalPages != null && book.totalPages! > 0
        ? book.currentPage / book.totalPages!
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.stackGap),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: SizedBox(
                width: 80,
                height: 120,
                child: book.coverUrl != null
                    ? Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const _BookCoverPlaceholder(),
                      )
                    : const _BookCoverPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    book.title,
                    style: AppTypography.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
                  const SizedBox(height: 10),
                  if (book.status == BookStatus.reading &&
                      book.totalPages != null)
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor:
                                AppColors.surfaceContainerHighest,
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).round()}%',
                          style: AppTypography.labelMdVariant(),
                        ),
                      ],
                    )
                  else
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: book.genres
                          .take(2)
                          .map((g) => TagChip(label: g))
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
