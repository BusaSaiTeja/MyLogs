import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/data/anilist_anime_service.dart';
import 'package:my_logs/features/watch/data/tmdb_service.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/watch/presentation/widgets/media_rating_selector.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';

class MediaFormSuggestion {
  const MediaFormSuggestion({
    required this.title,
    this.year,
    this.posterUrl,
    this.synopsis,
    this.language,
    this.genres = const [],
    this.totalEpisodes,
  });

  final String title;
  final int? year;
  final String? posterUrl;
  final String? synopsis;
  final String? language;
  final List<String> genres;
  final int? totalEpisodes;
}

class MediaFormScreen extends ConsumerStatefulWidget {
  const MediaFormScreen({super.key, required this.category, this.itemId});
  final MediaCategory category;
  final String? itemId;

  @override
  ConsumerState<MediaFormScreen> createState() => _MediaFormScreenState();
}

class _MediaFormScreenState extends ConsumerState<MediaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _synopsisCtrl;
  late final TextEditingController _genresCtrl;
  late final TextEditingController _languageCtrl;
  late final TextEditingController _posterUrlCtrl;
  late final TextEditingController _totalEpsCtrl;

  final FocusNode _titleFocus = FocusNode();

  MediaStatus _status = MediaStatus.planToWatch;
  double? _rating;
  bool _isEdit = false;

  Timer? _debounceTimer;
  List<MediaFormSuggestion> _suggestions = [];
  bool _isLoadingSuggestions = false;
  bool _showNoResultsMsg = false;
  bool _suggestionDismissed = false;

  final TmdbService _tmdbService = TmdbService();
  final AniListAnimeService _animeService = AniListAnimeService();

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _yearCtrl = TextEditingController();
    _synopsisCtrl = TextEditingController();
    _genresCtrl = TextEditingController();
    _languageCtrl = TextEditingController();
    _posterUrlCtrl = TextEditingController();
    _totalEpsCtrl = TextEditingController();

    if (widget.itemId != null) {
      _isEdit = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final item = ref.read(mediaByIdProvider(widget.itemId!));
        if (item == null) return;
        _titleCtrl.text = item.title;
        _yearCtrl.text = item.year?.toString() ?? '';
        _synopsisCtrl.text = item.synopsis ?? '';
        _genresCtrl.text = item.genres.join(', ');
        _languageCtrl.text = item.language ?? '';
        _posterUrlCtrl.text = item.posterUrl ?? '';
        _totalEpsCtrl.text = item.totalEpisodes?.toString() ?? '';
        setState(() {
          _status = item.status;
          _rating = item.rating;
        });
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    _synopsisCtrl.dispose();
    _genresCtrl.dispose();
    _languageCtrl.dispose();
    _posterUrlCtrl.dispose();
    _totalEpsCtrl.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  void _onTitleChanged(String query) {
    _suggestionDismissed = false;
    _debounceTimer?.cancel();

    if (query.trim().length < 2) {
      setState(() {
        _suggestions = [];
        _isLoadingSuggestions = false;
        _showNoResultsMsg = false;
      });
      return;
    }

    setState(() {
      _isLoadingSuggestions = true;
      _showNoResultsMsg = false;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 450), () async {
      List<MediaFormSuggestion> results = [];
      final cleanQ = query.trim().toLowerCase();

      if (widget.category == MediaCategory.anime) {
        // Query TMDB TV search + AniList search in parallel
        final tmdbTvFuture = _tmdbService.searchTv(query);
        final aniListFuture = _animeService.searchAnime(query);

        final searchResponses = await Future.wait([tmdbTvFuture, aniListFuture]);
        final tmdbTvResults = searchResponses[0] as List<TmdbSearchResult>;
        final aniListResults = searchResponses[1] as List<AnimeSearchResult>;

        final seenTitles = <String>{};

        for (final m in tmdbTvResults) {
          final tLower = m.title.toLowerCase();
          if (seenTitles.add(tLower)) {
            results.add(MediaFormSuggestion(
              title: m.title,
              year: m.year,
              posterUrl: m.posterUrl,
              synopsis: m.synopsis,
              genres: m.genres,
              language: 'Japanese',
            ));
          }
        }

        for (final a in aniListResults) {
          final tLower = a.title.toLowerCase();
          if (seenTitles.add(tLower)) {
            results.add(MediaFormSuggestion(
              title: a.title,
              year: a.year,
              posterUrl: a.posterUrl,
              synopsis: a.synopsis,
              genres: a.genres,
              language: 'Japanese',
              totalEpisodes: a.totalEpisodes,
            ));
          }
        }

        // Sort items starting with query first
        results.sort((a, b) {
          final startsA = a.title.toLowerCase().startsWith(cleanQ);
          final startsB = b.title.toLowerCase().startsWith(cleanQ);
          if (startsA && !startsB) return -1;
          if (!startsA && startsB) return 1;
          return 0;
        });
      } else {
        final tmdbResults = await _tmdbService.searchMovies(query);
        results = tmdbResults
            .map((m) => MediaFormSuggestion(
                  title: m.title,
                  year: m.year,
                  posterUrl: m.posterUrl,
                  synopsis: m.synopsis,
                  genres: m.genres,
                  language: m.language,
                ))
            .toList();
      }

      if (!mounted) return;
      setState(() {
        _isLoadingSuggestions = false;
        _suggestions = results.take(7).toList();
        _showNoResultsMsg = results.isEmpty && !_suggestionDismissed;
      });
    });
  }

  void _applySuggestion(MediaFormSuggestion result) {
    _titleFocus.unfocus();
    setState(() {
      _titleCtrl.text = result.title;
      if (result.year != null) _yearCtrl.text = '${result.year}';
      if (result.posterUrl != null) _posterUrlCtrl.text = result.posterUrl!;
      if (result.synopsis != null) _synopsisCtrl.text = result.synopsis!;
      if (result.language != null) _languageCtrl.text = result.language!;
      if (result.genres.isNotEmpty) _genresCtrl.text = result.genres.join(', ');
      if (result.totalEpisodes != null) _totalEpsCtrl.text = '${result.totalEpisodes}';
      _suggestions = [];
      _isLoadingSuggestions = false;
      _showNoResultsMsg = false;
      _suggestionDismissed = true;
    });
  }

  void _clearSuggestions() {
    setState(() {
      _suggestions = [];
      _showNoResultsMsg = false;
      _suggestionDismissed = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final genres = _genresCtrl.text
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
    final now = DateTime.now();

    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      if (_isEdit && widget.itemId != null) {
        final existing = ref.read(mediaByIdProvider(widget.itemId!));
        if (existing == null) return;
        await ref.read(mediaListProvider.notifier).updateItem(
              existing.copyWith(
                title: _titleCtrl.text.trim(),
                status: _status,
                rating: _rating,
                posterUrl: _posterUrlCtrl.text.trim().isEmpty ? null : _posterUrlCtrl.text.trim(),
                year: int.tryParse(_yearCtrl.text),
                genres: genres,
                language: _languageCtrl.text.trim().isEmpty ? null : _languageCtrl.text.trim(),
                synopsis: _synopsisCtrl.text.trim().isEmpty ? null : _synopsisCtrl.text.trim(),
                totalEpisodes: int.tryParse(_totalEpsCtrl.text),
                updatedAt: now,
              ),
            );
      } else {
        final activeWorkspaceId = ref.read(activeWorkspaceIdProvider).valueOrNull ?? '';
        await ref.read(mediaListProvider.notifier).add(
              MediaItem(
                id: '',
                workspaceId: activeWorkspaceId,
                title: _titleCtrl.text.trim(),
                category: widget.category,
                status: _status,
                rating: _rating,
                posterUrl: _posterUrlCtrl.text.trim().isEmpty ? null : _posterUrlCtrl.text.trim(),
                year: int.tryParse(_yearCtrl.text),
                genres: genres,
                language: _languageCtrl.text.trim().isEmpty ? null : _languageCtrl.text.trim(),
                synopsis: _synopsisCtrl.text.trim().isEmpty ? null : _synopsisCtrl.text.trim(),
                totalEpisodes: int.tryParse(_totalEpsCtrl.text),
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      if (!mounted) return;
      router.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to save media log: $e')),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Log'),
        content: const Text('Are you sure you want to delete this log?'),
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
    if (confirm == true && mounted) {
      final router = GoRouter.of(context);
      final canPop = router.canPop();
      await ref.read(mediaListProvider.notifier).delete(widget.itemId!);
      if (mounted) canPop ? router.pop() : router.go('/watch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocus.unfocus();
        _clearSuggestions();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primary,
            onPressed: () => context.canPop() ? context.pop() : context.go('/watch'),
          ),
          title: Text(
            _isEdit ? 'Edit ${widget.category.label}' : 'Add ${widget.category.label}',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary),
          ),
          centerTitle: false,
          actions: [
            if (_isEdit && widget.itemId != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.error,
                onPressed: _confirmDelete,
              ),
            TextButton(
              onPressed: _save,
              child: Text('Save', style: AppTypography.labelMdPrimary()),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            children: [
              // ── Title + Live Search ───────────────────────────────────────
              _label('${widget.category.label} Title *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleCtrl,
                focusNode: _titleFocus,
                onChanged: _onTitleChanged,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                decoration: InputDecoration(
                  hintText: widget.category == MediaCategory.anime
                      ? 'e.g. Naruto, Attack on Titan, One Piece'
                      : 'e.g. Inception, Toy Story',
                  suffixIcon: _isLoadingSuggestions
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search_rounded, color: AppColors.outline),
                ),
                style: AppTypography.bodyLg,
              ),

              // ── Suggestion Dropdown ───────────────────────────────────────
              if (_suggestions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 260),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    boxShadow: AppColors.cardShadow,
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: AppColors.outline.withValues(alpha: 0.1),
                      ),
                      itemBuilder: (_, i) {
                        final item = _suggestions[i];
                        final epInfo = item.totalEpisodes != null ? ' • ${item.totalEpisodes} eps' : '';
                        final genreInfo = item.genres.isNotEmpty ? ' • ${item.genres.take(2).join(', ')}' : '';
                        final subText = '${item.year ?? ''}$epInfo$genreInfo';

                        return ListTile(
                          dense: true,
                          leading: item.posterUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: item.posterUrl!,
                                    width: 32,
                                    height: 46,
                                    fit: BoxFit.cover,
                                    placeholder: (_, _) => Container(
                                      width: 32,
                                      height: 46,
                                      color: AppColors.surfaceContainerLow,
                                    ),
                                    errorWidget: (_, _, _) => Container(
                                      width: 32,
                                      height: 46,
                                      color: AppColors.surfaceContainerLow,
                                      child: const Icon(Icons.movie_outlined, size: 16),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 32,
                                  height: 46,
                                  color: AppColors.surfaceContainerLow,
                                  child: const Icon(Icons.movie_outlined, size: 16),
                                ),
                          title: Text(
                            item.title,
                            style: AppTypography.bodyLg.copyWith(fontSize: 14),
                          ),
                          subtitle: Text(
                            subText.isEmpty ? 'Anime / Media' : subText,
                            style: AppTypography.bodyMdVariant().copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _applySuggestion(item),
                        );
                      },
                    ),
                  ),
                ),
              ],

              // ── No Results Message ───────────────────────────────────────
              if (_showNoResultsMsg) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Couldn't find that online — enter details manually below.",
                        style: AppTypography.labelMdOutline().copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppSpacing.stackGap),

              // ── Watch Status ──────────────────────────────────────────────
              _label('Watch Status'),
              const SizedBox(height: 6),
              DropdownButtonFormField<MediaStatus>(
                initialValue: _status,
                decoration: const InputDecoration(),
                onChanged: (s) => setState(() => _status = s!),
                items: MediaStatus.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                    .toList(),
              ),

              const SizedBox(height: AppSpacing.stackGap),

              // ── Rating (1 - 10) ───────────────────────────────────────────
              _label('Rating (1 - 10)'),
              const SizedBox(height: 8),
              MediaRatingSelector(
                rating: _rating,
                onRatingChanged: (r) => setState(() => _rating = r),
              ),

              const SizedBox(height: AppSpacing.stackGap),

              // ── Details Section (Auto-filled • Editable) ─────────────────
              _label('${widget.category.label} Details  (auto-filled • editable)'),
              const SizedBox(height: 12),
              _field('Year', _yearCtrl, hint: 'e.g. 2010', keyboard: TextInputType.number),
              _field('Language', _languageCtrl, hint: 'e.g. English, Japanese'),
              _field('Poster Image URL', _posterUrlCtrl,
                  hint: 'https://...', keyboard: TextInputType.url),
              _field('Genres (comma-separated)', _genresCtrl, hint: 'Sci-Fi, Action, Thriller'),
              if (widget.category == MediaCategory.anime)
                _field('Total Episodes', _totalEpsCtrl,
                    hint: 'e.g. 24', keyboard: TextInputType.number),
              _field('Synopsis', _synopsisCtrl, maxLines: 4, hint: 'Short overview...'),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTypography.labelMdVariant());

  Widget _field(String label, TextEditingController controller,
      {bool required = false,
      String? hint,
      TextInputType? keyboard,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.stackGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboard,
            validator: required ? (v) => v == null || v.trim().isEmpty ? 'Required' : null : null,
            decoration: InputDecoration(hintText: hint),
            style: AppTypography.bodyLg,
          ),
        ],
      ),
    );
  }
}
