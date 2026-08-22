import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class CurrentlyReadingTile extends StatelessWidget {
  const CurrentlyReadingTile({super.key, required this.book, required this.onTap});
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
        margin: const EdgeInsets.only(bottom: AppSpacing.unit * 2),
        padding: const EdgeInsets.all(AppSpacing.gutter),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Row(
          children: [
            if (book.coverUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: SizedBox(
                  width: 48,
                  height: 72,
                  child: Image.network(
                    book.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceContainerHigh),
                  ),
                ),
              )
            else
              Container(
                width: 48,
                height: 72,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.book_outlined, size: 24, color: AppColors.outline),
              ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(book.author, style: AppTypography.bodyMdOutline()),
                  const SizedBox(height: 8),
                  AppProgressBar(progress: progress),
                  const SizedBox(height: 4),
                  Text(
                    '${book.currentPage} / ${book.totalPages ?? '?'} pages',
                    style: AppTypography.labelMdOutline(),
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
