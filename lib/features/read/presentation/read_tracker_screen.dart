import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/core/widgets/status_chip.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

class ReadTrackerScreen extends ConsumerStatefulWidget {
  const ReadTrackerScreen({super.key});

  @override
  ConsumerState<ReadTrackerScreen> createState() => _ReadTrackerScreenState();
}

class _ReadTrackerScreenState extends ConsumerState<ReadTrackerScreen> {
  int _selectedTab = 0;
  static const _tabs = ['To Read', 'Reading', 'Read', 'Collection'];
  static const _statuses = [
    BookStatus.toRead,
    BookStatus.reading,
    BookStatus.read,
    BookStatus.collection,
  ];

  @override
  Widget build(BuildContext context) {
    final currentStatus = _statuses[_selectedTab];
    final books = ref.watch(booksByStatusProvider(currentStatus));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.go('/'),
        ),
        title: Text('Read Tracker', style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppColors.primary,
            onPressed: () => context.push('/read/add'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            color: AppColors.onSurfaceVariant,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding, AppSpacing.stackGap, AppSpacing.containerPadding, 0),
            child: PillTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onTabSelected: (i) => setState(() => _selectedTab = i),
            ),
          ),
          const SizedBox(height: AppSpacing.stackGap),
          Expanded(
            child: books.isEmpty
                ? EmptyState(
                    icon: Icons.book_outlined,
                    title: 'No books here yet',
                    subtitle: 'Add your first book to your library',
                    actionLabel: 'Add Book',
                    onAction: () => context.push('/read/add'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.containerPadding,
                        vertical: AppSpacing.unit),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 3.2,
                      crossAxisSpacing: AppSpacing.gutter,
                      mainAxisSpacing: AppSpacing.unit * 2,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, i) => _BookCard(
                      book: books[i],
                      onTap: () => context.push('/read/${books[i].id}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book, required this.onTap});
  final BookItem book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = book.totalPages != null && book.totalPages! > 0
        ? book.currentPage / book.totalPages!
        : 0.0;

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.unit),
          child: Row(
            children: [
              // Cover
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: SizedBox(
                  width: 72,
                  height: double.infinity,
                  child: book.coverUrl != null
                      ? Image.network(book.coverUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const _BookCoverPlaceholder())
                      : const _BookCoverPlaceholder(),
                ),
              ),
              const SizedBox(width: AppSpacing.gutter),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title,
                          style: AppTypography.headlineMd,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(book.author, style: AppTypography.bodyMdVariant(), maxLines: 1),
                      const Spacer(),
                      if (book.status == BookStatus.reading && book.totalPages != null)
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.surfaceContainerHighest,
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${(progress * 100).round()}%',
                                style: AppTypography.labelMdVariant()),
                          ],
                        )
                      else
                        Wrap(
                          spacing: 4,
                          children: book.genres
                              .take(2)
                              .map((g) => TagChip(label: g))
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      child: Center(child: Icon(Icons.book_outlined, color: AppColors.outline, size: 28)),
    );
  }
}
