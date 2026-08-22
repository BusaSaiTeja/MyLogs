import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';
import 'package:my_logs/features/read/presentation/widgets/book_card.dart';

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
        title: Text('Read Tracker',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
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
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.containerPadding),
                    itemCount: books.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
                      child: BookCard(
                        book: books[i],
                        onTap: () => context.push('/read/${books[i].id}'),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
