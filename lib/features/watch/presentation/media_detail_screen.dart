import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/core/widgets/progress_bar.dart';
import 'package:my_logs/core/widgets/rating_stars.dart';
import 'package:my_logs/core/widgets/status_chip.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

class MediaDetailScreen extends ConsumerStatefulWidget {
  const MediaDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends ConsumerState<MediaDetailScreen> {
  late TextEditingController _notesController;
  bool _notesChanged = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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

    // Sync notes controller with item
    if (!_notesChanged) {
      _notesController.text = item.notes ?? '';
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
                backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.onSurface,
                  onPressed: () => context.go('/'),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurface),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.posterUrl != null)
                    Image.network(item.posterUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const ColoredBox(color: AppColors.surfaceContainerHigh))
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
                        Text('${item.year}', style: AppTypography.bodyMdVariant()),
                      Text('•', style: AppTypography.bodyMdVariant()),
                      Text(item.category.label, style: AppTypography.bodyMdVariant()),
                      if (item.language != null) ...[
                        Text('•', style: AppTypography.bodyMdVariant()),
                        Text(item.language!, style: AppTypography.bodyMdVariant()),
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

                  // ── Status & Rating card ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.stackGap),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status', style: AppTypography.labelMdVariant()),
                                  const SizedBox(height: 4),
                                  _StatusDropdown(
                                    value: item.status,
                                    onChanged: (s) {
                                      if (s != null) {
                                        ref.read(mediaListProvider.notifier).updateStatus(item.id, s);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.stackGap),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Your Rating', style: AppTypography.labelMdVariant()),
                                const SizedBox(height: 4),
                                RatingStars(
                                  rating: item.rating,
                                  starSize: 28,
                                  onRatingChanged: (r) => ref
                                      .read(mediaListProvider.notifier)
                                      .updateRating(item.id, r),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Episode progress (anime/series)
                        if (item.totalEpisodes != null) ...[
                          const SizedBox(height: AppSpacing.stackGap),
                          const Divider(color: AppColors.surfaceContainerHighest, height: 1),
                          const SizedBox(height: AppSpacing.stackGap),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Episode Progress', style: AppTypography.labelMdVariant()),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${item.episodesWatched}',
                                            style: AppTypography.headlineMd,
                                          ),
                                          TextSpan(
                                            text: ' / ${item.totalEpisodes}',
                                            style: AppTypography.bodyMdVariant(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: IconButton(
                                  icon: const Icon(Icons.add_rounded, color: AppColors.onPrimary),
                                  onPressed: () => ref
                                      .read(mediaListProvider.notifier)
                                      .incrementEpisode(item.id),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AppProgressBar(
                            progress: item.totalEpisodes! > 0
                                ? item.episodesWatched / item.totalEpisodes!
                                : 0,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.groupGap),

                  // ── Synopsis ──────────────────────────────────────────
                  if (item.synopsis != null) ...[
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
                          Text('SYNOPSIS',
                              style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  letterSpacing: 1.2)),
                          const SizedBox(height: 8),
                          Text(item.synopsis!, style: AppTypography.bodyMd),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.groupGap),
                  ],

                  // ── Notes / Review ────────────────────────────────────
                  Text('Personal Notes & Review', style: AppTypography.headlineMd),
                  const SizedBox(height: AppSpacing.stackGap),
                  TextField(
                    controller: _notesController,
                    maxLines: 6,
                    onChanged: (_) => setState(() => _notesChanged = true),
                    decoration: const InputDecoration(
                      hintText: 'Write your thoughts here...',
                      alignLabelWithHint: true,
                    ),
                    style: AppTypography.bodyLg,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Save FAB ──────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(mediaListProvider.notifier).updateNotes(widget.id, _notesController.text);
          setState(() => _notesChanged = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log saved!')),
          );
        },
        icon: const Icon(Icons.save_rounded),
        label: const Text('Save Log'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({required this.value, required this.onChanged});
  final MediaStatus value;
  final ValueChanged<MediaStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MediaStatus>(
          value: value,
          onChanged: onChanged,
          isDense: true,
          style: AppTypography.bodyMd,
          items: MediaStatus.values
              .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
              .toList(),
        ),
      ),
    );
  }
}
