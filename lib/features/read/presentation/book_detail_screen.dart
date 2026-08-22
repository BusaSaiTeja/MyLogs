import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/core/widgets/rating_stars.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  const BookDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  late TextEditingController _notesCtrl;
  late TextEditingController _pageCtrl;
  bool _notesChanged = false;

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController();
    _pageCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(bookByIdProvider(widget.id));
    if (book == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Book not found')),
      );
    }

    if (!_notesChanged) _notesCtrl.text = book.notes ?? '';
    _pageCtrl.text = book.currentPage.toString();

    final progress =
        book.totalPages != null && book.totalPages! > 0 ? book.currentPage / book.totalPages! : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text('Book Details',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppColors.primary,
            onPressed: () => context.push('/read/${widget.id}/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          // Header
          Row(
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
                          child: Center(child: Icon(Icons.book_outlined, size: 40, color: AppColors.outline))),
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
                      onRatingChanged: (r) =>
                          ref.read(bookListProvider.notifier).updateRating(book.id, r),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.groupGap),

          // Status & Progress card
          Container(
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
                  onChanged: (s) {
                    if (s != null) ref.read(bookListProvider.notifier).updateStatus(book.id, s);
                  },
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
                          controller: _pageCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Page'),
                          style: AppTypography.bodyLg,
                          onSubmitted: (v) {
                            final page = int.tryParse(v) ?? book.currentPage;
                            ref.read(bookListProvider.notifier).updateProgress(
                                book.id, page.clamp(0, book.totalPages!));
                          },
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
          ),
          const SizedBox(height: AppSpacing.groupGap),

          // Notes
          Text('Notes & Review', style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.stackGap),
          TextField(
            controller: _notesCtrl,
            maxLines: 6,
            onChanged: (_) => setState(() => _notesChanged = true),
            decoration: const InputDecoration(hintText: 'Your thoughts about this book...'),
            style: AppTypography.bodyLg,
          ),
          const SizedBox(height: AppSpacing.groupGap),
          ElevatedButton(
            onPressed: () {
              ref.read(bookListProvider.notifier).updateNotes(book.id, _notesCtrl.text);
              setState(() => _notesChanged = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved!')),
              );
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
