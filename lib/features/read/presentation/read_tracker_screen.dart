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
import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

class ReadTrackerScreen extends ConsumerStatefulWidget {
  const ReadTrackerScreen({super.key});

  @override
  ConsumerState<ReadTrackerScreen> createState() => _ReadTrackerScreenState();
}

class _ReadTrackerScreenState extends ConsumerState<ReadTrackerScreen> {
  int _selectedTab = 0;
  final PageController _pageController = PageController();

  static const _tabs = ['Reading', 'Read', 'To Read', 'Collection'];
  static const _statuses = [
    BookStatus.reading,
    BookStatus.read,
    BookStatus.toRead,
    BookStatus.collection,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _selectedTab = index);
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          color: AppColors.obsidian,
          tooltip: 'Open menu',
          onPressed: () {
            if (rootScaffoldKey.currentState?.isDrawerOpen == true) {
              rootScaffoldKey.currentState?.closeDrawer();
            } else {
              rootScaffoldKey.currentState?.openDrawer();
            }
          },
        ),
        title: Text('Read Tracker',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.obsidian)),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurfaceVariant),
            tooltip: 'More options',
            onSelected: (value) {
              if (value == 'disable') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Disable feature (Coming in Phase 3)'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (value == 'hide') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hide feature (Coming in Phase 3)'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'disable',
                child: Row(
                  children: [
                    Icon(Icons.block_rounded, size: 20, color: AppColors.onSurfaceVariant),
                    SizedBox(width: 12),
                    Text('Disable Feature'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'hide',
                child: Row(
                  children: [
                    Icon(Icons.visibility_off_outlined, size: 20, color: AppColors.onSurfaceVariant),
                    SizedBox(width: 12),
                    Text('Hide Feature'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'read_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => context.push('/read/add'),
        child: const Icon(Icons.add_rounded),
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
              onTabSelected: _onTabSelected,
            ),
          ),
          const SizedBox(height: AppSpacing.stackGap),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _statuses.length,
              onPageChanged: (i) => setState(() => _selectedTab = i),
              itemBuilder: (context, tabIdx) {
                final status = _statuses[tabIdx];
                final books = ref.watch(booksByStatusProvider(status));

                if (books.isEmpty) {
                  return EmptyState(
                    icon: Icons.book_outlined,
                    title: 'No ${_tabs[tabIdx].toLowerCase()} books',
                    subtitle: 'Add your first book to your library',
                    actionLabel: 'Add Book',
                    onAction: () => context.push('/read/add'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: books.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: BookCard(
                      book: books[i],
                      onTap: () => context.push('/read/${books[i].id}'),
                      onDelete: () => ref.read(bookListProvider.notifier).delete(books[i].id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
