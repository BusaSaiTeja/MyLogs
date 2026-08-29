import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
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
  bool _notesInitialised = false;
  Timer? _notesDebounce;
  bool _savedIndicator = false;

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _notesDebounce?.cancel();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _onNotesChanged(String bookId) {
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 800), () async {
      await ref.read(bookListProvider.notifier).updateNotes(bookId, _notesCtrl.text);
      if (!mounted) return;
      setState(() => _savedIndicator = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _savedIndicator = false);
      });
    });
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

    // Initialise notes controller once from book data
    if (!_notesInitialised) {
      _notesCtrl.text = book.notes ?? '';
      _notesInitialised = true;
    }

    final isInCollection = book.isCollection || book.status == BookStatus.collection;
    final currentReadingStatus = (book.status == BookStatus.collection) ? BookStatus.toRead : book.status;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero Banner ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.onSurface,
                  onPressed: () => context.canPop() ? context.pop() : context.go('/read'),
                ),
              ),
            ),
            actions: [
              if (_savedIndicator)
                Padding(
                  padding: const EdgeInsets.only(right: 4, top: 8, bottom: 8),
                  child: CircleAvatar(
                    backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                    child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 18),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Book'),
                          content: const Text('Are you sure you want to delete this book?'),
                          actions: [
                            TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () => ctx.pop(true),
                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        ref.read(bookListProvider.notifier).delete(widget.id);
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/read');
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (book.coverUrl != null)
                    CachedNetworkImage(
                      imageUrl: book.coverUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          const ColoredBox(color: AppColors.surfaceContainerHigh),
                      errorWidget: (_, _, _) =>
                          const ColoredBox(color: AppColors.surfaceContainerHigh),
                    )
                  else
                    const ColoredBox(color: AppColors.surfaceContainerHigh),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title & Author ─────────────────────────────────────
                  Text(book.title, style: AppTypography.display),
                  const SizedBox(height: AppSpacing.unit * 2),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(book.author, style: AppTypography.bodyMdVariant()),
                      if (book.totalPages != null) ...[
                        Text('•', style: AppTypography.bodyMdVariant()),
                        const Icon(Icons.menu_book_outlined, size: 13, color: AppColors.outline),
                        Text('${book.totalPages} pages', style: AppTypography.bodyMdVariant()),
                      ],
                    ],
                  ),

                  // ── Genre tags ─────────────────────────────────────────
                  if (book.genres.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.stackGap),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: book.genres
                          .map((g) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                ),
                                child: Text(g, style: AppTypography.labelMd),
                              ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.groupGap),

                  // ── Status, Rating & Collection Card ───────────────────
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.stackGap),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Reading Status Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reading Status', style: AppTypography.labelMdVariant()),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<BookStatus>(
                                        value: currentReadingStatus,
                                        onChanged: (s) {
                                          if (s != null) {
                                            ref.read(bookListProvider.notifier).updateStatus(book.id, s);
                                          }
                                        },
                                        isDense: true,
                                        style: AppTypography.bodyMd,
                                        items: [
                                          BookStatus.reading,
                                          BookStatus.read,
                                          BookStatus.toRead,
                                          BookStatus.onHold,
                                          BookStatus.dropped,
                                        ]
                                            .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.stackGap),
                            // Rating
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your Rating', style: AppTypography.labelMdVariant()),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RatingStars(
                                      rating: book.rating,
                                      starSize: 24,
                                      onRatingChanged: (r) =>
                                          ref.read(bookListProvider.notifier).updateRating(book.id, r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Collection Toggle Tile ───────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isInCollection
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            border: Border.all(
                              color: isInCollection
                                  ? AppColors.primary.withValues(alpha: 0.35)
                                  : AppColors.surfaceContainerHighest,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isInCollection
                                    ? Icons.collections_bookmark_rounded
                                    : Icons.collections_bookmark_outlined,
                                size: 20,
                                color: isInCollection
                                    ? AppColors.primary
                                    : AppColors.outline,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'In My Collection',
                                      style: AppTypography.bodyMd.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isInCollection
                                            ? AppColors.primary
                                            : AppColors.onSurface,
                                      ),
                                    ),
                                    Text(
                                      isInCollection
                                          ? 'Book is part of your permanent library'
                                          : 'Toggle to save to your collection tab',
                                      style: AppTypography.labelMdVariant().copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: isInCollection,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  ref.read(bookListProvider.notifier).toggleCollection(book.id, val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.groupGap),



                  // ── Synopsis ───────────────────────────────────────────
                  if (book.synopsis != null && book.synopsis!.isNotEmpty) ...[
                    Text('Synopsis', style: AppTypography.headlineMd),
                    const SizedBox(height: AppSpacing.stackGap),
                    Text(book.synopsis!, style: AppTypography.bodyMd),
                    const SizedBox(height: AppSpacing.groupGap),
                  ],

                  // ── Personal notes ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Personal Notes', style: AppTypography.headlineMd),
                      Text('Auto-saved', style: AppTypography.labelMdVariant()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackGap),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 6,
                    onChanged: (_) => _onNotesChanged(book.id),
                    decoration: const InputDecoration(
                      hintText: 'Add thoughts, quotes, chapter summaries...',
                    ),
                    style: AppTypography.bodyMd,
                  ),
                  const SizedBox(height: AppSpacing.groupGap * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
