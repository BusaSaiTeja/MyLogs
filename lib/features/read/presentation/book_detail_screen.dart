import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/presentation/widgets/book_detail_header.dart';
import 'package:my_logs/features/read/presentation/widgets/book_detail_progress_card.dart';

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
          BookDetailHeader(
            book: book,
            onRatingChanged: (r) =>
                ref.read(bookListProvider.notifier).updateRating(book.id, r),
          ),
          const SizedBox(height: AppSpacing.groupGap),

          // Status & Progress card
          BookDetailProgressCard(
            book: book,
            pageCtrl: _pageCtrl,
            onStatusChanged: (s) {
              if (s != null) ref.read(bookListProvider.notifier).updateStatus(book.id, s);
            },
            onProgressSubmitted: (v) {
              final page = int.tryParse(v) ?? book.currentPage;
              ref.read(bookListProvider.notifier).updateProgress(
                  book.id, page.clamp(0, book.totalPages ?? 0));
            },
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
