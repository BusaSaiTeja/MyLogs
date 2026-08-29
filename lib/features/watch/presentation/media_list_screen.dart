import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/empty_state.dart';
import 'package:my_logs/core/widgets/pill_tab_bar.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/watch/presentation/widgets/media_card.dart';

class MediaListScreen extends ConsumerStatefulWidget {
  const MediaListScreen({super.key, required this.category});
  final MediaCategory category;

  @override
  ConsumerState<MediaListScreen> createState() => _MediaListScreenState();
}

class _MediaListScreenState extends ConsumerState<MediaListScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';
  final PageController _pageController = PageController();

  static const _tabs = ['Plan to Watch', 'Watching', 'Completed', 'On Hold', 'Dropped'];
  static const _statuses = [
    MediaStatus.planToWatch,
    MediaStatus.watching,
    MediaStatus.completed,
    MediaStatus.onHold,
    MediaStatus.dropped,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _addRoute => switch (widget.category) {
        MediaCategory.movie => '/watch/movies/add',
        MediaCategory.animatedMovie => '/watch/animated/add',
        MediaCategory.anime => '/watch/anime/add',
      };

  String _detailRoute(String id) => switch (widget.category) {
        MediaCategory.movie => '/watch/movies/$id',
        MediaCategory.animatedMovie => '/watch/animated/$id',
        MediaCategory.anime => '/watch/anime/$id',
      };

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
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.canPop() ? context.pop() : context.go('/watch'),
        ),
        title: Text(widget.category.label,
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => context.push(_addRoute),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          // ── Search bar ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.category.label.toLowerCase()}...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.outline),
                    ),
                    style: AppTypography.bodyLg,
                  ),
                ),
              ],
            ),
          ),
          // ── Tab bar ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: PillTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onTabSelected: _onTabSelected,
            ),
          ),
          // ── Swipeable PageView List ───────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _statuses.length,
              onPageChanged: (i) => setState(() => _selectedTab = i),
              itemBuilder: (context, tabIdx) {
                final status = _statuses[tabIdx];
                final items = ref.watch(mediaByCategoryAndStatus((widget.category, status)));
                final filtered = _searchQuery.isEmpty
                    ? items
                    : items
                        .where((m) =>
                            m.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.movie_outlined,
                    title: 'No ${_tabs[tabIdx].toLowerCase()} items',
                    subtitle: 'Add your first ${widget.category.label.toLowerCase()}',
                    actionLabel: 'Add',
                    onAction: () => context.push(_addRoute),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10.0),
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    return MediaCard(
                      item: item,
                      onTap: () => context.push(_detailRoute(item.id)),
                      onDelete: () =>
                          ref.read(mediaListProvider.notifier).delete(item.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
