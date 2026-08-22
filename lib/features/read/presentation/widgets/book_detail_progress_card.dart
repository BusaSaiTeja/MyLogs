import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class BookDetailProgressCard extends StatelessWidget {
  const BookDetailProgressCard({
    super.key,
    required this.book,
    required this.pageCtrl,
    required this.onStatusChanged,
    required this.onProgressSubmitted,
  });

  final BookItem book;
  final TextEditingController pageCtrl;
  final ValueChanged<BookStatus?> onStatusChanged;
  final ValueChanged<String> onProgressSubmitted;

  @override
  Widget build(BuildContext context) {
    final progress = book.totalPages != null && book.totalPages! > 0
        ? book.currentPage / book.totalPages!
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackGap),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status', style: AppTypography.labelMdVariant()),
          const SizedBox(height: 6),
          DropdownButtonFormField<BookStatus>(
            initialValue: book.status,
            decoration: const InputDecoration(),
            onChanged: onStatusChanged,
            items: BookStatus.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                .toList(),
          ),
          if (book.totalPages != null) ...[
            const SizedBox(height: AppSpacing.stackGap),
            const Divider(color: AppColors.surfaceContainerHighest, height: 1),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Reading Progress', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: pageCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Page'),
                    style: AppTypography.bodyLg,
                    onSubmitted: onProgressSubmitted,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('/ ${book.totalPages}', style: AppTypography.bodyLgVariant()),
                ),
                Expanded(
                  child: AppProgressBar(progress: progress),
                ),
                const SizedBox(width: 8),
                Text('${(progress * 100).round()}%', style: AppTypography.labelMdVariant()),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
