import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/watch/presentation/widgets/media_detail_status_card.dart';

class MediaDetailScreen extends ConsumerStatefulWidget {
  const MediaDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends ConsumerState<MediaDetailScreen> {
  late TextEditingController _notesController;
  bool _notesInitialised = false;
  Timer? _notesDebounce;
  bool _savedIndicator = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesDebounce?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _onNotesChanged(String itemId) {
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 800), () async {
      await ref
          .read(mediaListProvider.notifier)
          .updateNotes(itemId, _notesController.text);
      if (!mounted) return;
      setState(() => _savedIndicator = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _savedIndicator = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(mediaByIdProvider(widget.id));

    if (item == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Item not found')),
      );
    }

    // Initialise notes controller once from item data
    if (!_notesInitialised) {
      _notesController.text = item.notes ?? '';
      _notesInitialised = true;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero banner ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceContainerLowest.withValues(
                  alpha: 0.85,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.onSurface,
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/watch'),
                ),
              ),
            ),
            actions: [
              if (_savedIndicator)
                Padding(
                  padding: const EdgeInsets.only(right: 4, top: 8, bottom: 8),
                  child: CircleAvatar(
                    backgroundColor: AppColors.surfaceContainerLowest
                        .withValues(alpha: 0.85),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: AppColors.surfaceContainerLowest.withValues(
                    alpha: 0.85,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: () async {
                      final router = GoRouter.of(context);
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Log'),
                          content: const Text(
                            'Are you sure you want to delete this log?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => ctx.pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => ctx.pop(true),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && mounted) {
                        final canPop = router.canPop();
                        await ref
                            .read(mediaListProvider.notifier)
                            .delete(widget.id);
                        if (mounted) {
                          canPop ? router.pop() : router.go('/watch');
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
                  if (item.posterUrl != null)
                    Image.network(
                      item.posterUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: AppColors.surfaceContainerHigh,
                      ),
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
                  // Title & meta
                  Text(item.title, style: AppTypography.display),
                  const SizedBox(height: AppSpacing.unit * 2),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (item.year != null)
                        Text(
                          '${item.year}',
                          style: AppTypography.bodyMdVariant(),
                        ),
                      Text('•', style: AppTypography.bodyMdVariant()),
                      Text(
                        item.category.label,
                        style: AppTypography.bodyMdVariant(),
                      ),
                      if (item.language != null) ...[
                        Text('•', style: AppTypography.bodyMdVariant()),
                        Text(
                          item.language!,
                          style: AppTypography.bodyMdVariant(),
                        ),
                      ],
                    ],
                  ),
                  // Genre tags
                  if (item.genres.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.stackGap),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.genres
                          .map(
                            (g) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull,
                                ),
                              ),
                              child: Text(g, style: AppTypography.labelMd),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.groupGap),

                  // ── Status & Rating card ──────────────────────────────
                  MediaDetailStatusCard(
                    item: item,
                    onStatusChanged: (s) {
                      if (s != null) {
                        ref
                            .read(mediaListProvider.notifier)
                            .updateStatus(item.id, s);
                      }
                    },
                    onRatingChanged: (r) => ref
                        .read(mediaListProvider.notifier)
                        .updateRating(item.id, r),
                  ),
                  const SizedBox(height: AppSpacing.groupGap),

                  // ── Synopsis ──────────────────────────────────────────
                  if (item.synopsis != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.stackGap),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusXl,
                        ),
                        border: Border.all(
                          color: AppColors.surfaceContainerHighest,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SYNOPSIS',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(item.synopsis!, style: AppTypography.bodyMd),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.groupGap),
                  ],

                  // ── Notes / Review ─────────────────────────────────────
                  Row(
                    children: [
                      Text('Notes & Review', style: AppTypography.headlineMd),
                      const Spacer(),
                      Text('Auto-saved', style: AppTypography.labelMdOutline()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackGap),
                  TextField(
                    controller: _notesController,
                    maxLines: 6,
                    onChanged: (_) => _onNotesChanged(item.id),
                    decoration: const InputDecoration(
                      hintText: 'Write your thoughts here...',
                      alignLabelWithHint: true,
                    ),
                    style: AppTypography.bodyLg,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
