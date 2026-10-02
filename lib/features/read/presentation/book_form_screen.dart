import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/data/google_books_service.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';

class BookFormScreen extends ConsumerStatefulWidget {
  const BookFormScreen({super.key, this.bookId});
  final String? bookId;

  @override
  ConsumerState<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends ConsumerState<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _authorCtrl;
  late final TextEditingController _coverCtrl;
  late final TextEditingController _totalPagesCtrl;
  late final TextEditingController _genresCtrl;
  late final TextEditingController _languageCtrl;

  final FocusNode _titleFocus = FocusNode();

  BookStatus _status = BookStatus.toRead;
  bool _addToCollection = false;
  bool _isEdit = false;

  Timer? _debounceTimer;
  List<GoogleBookSuggestion> _suggestions = [];
  bool _isLoadingSuggestions = false;
  bool _showNoResultsMsg = false;
  bool _suggestionDismissed = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _authorCtrl = TextEditingController();
    _coverCtrl = TextEditingController();
    _totalPagesCtrl = TextEditingController();
    _genresCtrl = TextEditingController();
    _languageCtrl = TextEditingController();

    if (widget.bookId != null) {
      _isEdit = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final book = ref.read(bookByIdProvider(widget.bookId!));
        if (book == null) return;
        _titleCtrl.text = book.title;
        _authorCtrl.text = book.author;
        _coverCtrl.text = book.coverUrl ?? '';
        _totalPagesCtrl.text = book.totalPages?.toString() ?? '';
        _genresCtrl.text = book.genres.join(', ');
        if (book.status == BookStatus.collection) {
          _status = BookStatus.toRead;
          _addToCollection = true;
        } else {
          _status = book.status;
          _addToCollection = book.isCollection;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _coverCtrl.dispose();
    _totalPagesCtrl.dispose();
    _genresCtrl.dispose();
    _languageCtrl.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  int _searchSessionId = 0;

  void _onTitleChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    final clean = query.trim();
    if (clean.length < 2) {
      _searchSessionId++;
      setState(() {
        _suggestions = [];
        _isLoadingSuggestions = false;
        _showNoResultsMsg = false;
      });
      return;
    }
    _suggestionDismissed = false;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () => _fetchSuggestions(clean));
  }

  Future<void> _fetchSuggestions(String query) async {
    final currentSession = ++_searchSessionId;
    setState(() {
      _isLoadingSuggestions = true;
      _showNoResultsMsg = false;
    });

    try {
      final results = await ref.read(googleBooksServiceProvider).searchBooks(query);
      if (!mounted || currentSession != _searchSessionId) return;

      setState(() {
        _suggestions = results;
        _isLoadingSuggestions = false;
        _showNoResultsMsg = results.isEmpty && !_suggestionDismissed && _titleCtrl.text.trim().length >= 2;
      });
    } catch (_) {
      if (!mounted || currentSession != _searchSessionId) return;
      setState(() {
        _isLoadingSuggestions = false;
        _showNoResultsMsg = true;
      });
    }
  }

  void _applySuggestion(GoogleBookSuggestion book) {
    _titleFocus.unfocus();
    setState(() {
      _titleCtrl.text = book.title;
      _authorCtrl.text = book.author;
      if (book.coverUrl != null && book.coverUrl!.isNotEmpty) {
        _coverCtrl.text = book.coverUrl!;
      }
      if (book.pageCount != null && book.pageCount! > 0) {
        _totalPagesCtrl.text = book.pageCount.toString();
      }
      if (book.categories.isNotEmpty) {
        _genresCtrl.text = book.categories.join(', ');
      }
      _suggestions = [];
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
    FocusScope.of(context).unfocus();
    final genres = _genresCtrl.text
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
    final now = DateTime.now();

    if (_isEdit && widget.bookId != null) {
      final existing = ref.read(bookByIdProvider(widget.bookId!));
      if (existing != null) {
        ref.read(bookListProvider.notifier).updateItem(existing.copyWith(
              title: _titleCtrl.text.trim(),
              author: _authorCtrl.text.trim(),
              coverUrl: _coverCtrl.text.trim().isEmpty ? null : _coverCtrl.text.trim(),
              totalPages: int.tryParse(_totalPagesCtrl.text),
              genres: genres,
              status: _status,
              isCollection: _addToCollection,
              updatedAt: now,
            ));
      }
    } else {
      final activeWorkspaceId = ref.read(activeWorkspaceIdProvider).valueOrNull ?? '';
      ref.read(bookListProvider.notifier).add(BookItem(
            id: '',
            workspaceId: activeWorkspaceId,
            title: _titleCtrl.text.trim(),
            author: _authorCtrl.text.trim(),
            coverUrl: _coverCtrl.text.trim().isEmpty ? null : _coverCtrl.text.trim(),
            totalPages: int.tryParse(_totalPagesCtrl.text),
            genres: genres,
            status: _status,
            isCollection: _addToCollection,
            createdAt: now,
            updatedAt: now,
          ));
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/read');
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
            onPressed: () => context.canPop() ? context.pop() : context.go('/read'),
          ),
          title: Text(
            _isEdit ? 'Edit Book' : 'Add Book',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary),
          ),
          centerTitle: false,
          actions: [
            if (_isEdit && widget.bookId != null)
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
              // ── Book Title + Live Search ──────────────────────────────────
              _label('Book Title *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleCtrl,
                focusNode: _titleFocus,
                onChanged: _onTitleChanged,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                decoration: InputDecoration(
                  hintText: 'e.g. Harry Potter, Atomic Habits',
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
                        return ListTile(
                          dense: true,
                          leading: item.coverUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: item.coverUrl!,
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
                                      child: const Icon(Icons.book, size: 16),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 32,
                                  height: 46,
                                  color: AppColors.surfaceContainerLow,
                                  child: const Icon(Icons.book, size: 16),
                                ),
                          title: Text(
                            item.title,
                            style: AppTypography.bodyLg.copyWith(fontSize: 14),
                          ),
                          subtitle: Text(
                            '${item.author}${item.pageCount != null ? " • ${item.pageCount} pgs" : ""}',
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

              // ── Status Dropdown ──────────────────────────────────────────
              _label('Reading Status'),
              const SizedBox(height: 6),
              DropdownButtonFormField<BookStatus>(
                initialValue: _status,
                decoration: const InputDecoration(),
                onChanged: (s) => setState(() => _status = s!),
                items: const [
                  DropdownMenuItem(value: BookStatus.toRead, child: Text('To Read')),
                  DropdownMenuItem(value: BookStatus.reading, child: Text('Reading')),
                  DropdownMenuItem(value: BookStatus.read, child: Text('Read')),
                  DropdownMenuItem(value: BookStatus.onHold, child: Text('On Hold')),
                  DropdownMenuItem(value: BookStatus.dropped, child: Text('Dropped')),
                ],
              ),

              const SizedBox(height: AppSpacing.stackGap),

              // ── Add to Collection ────────────────────────────────────────
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                value: _addToCollection,
                onChanged: (val) => setState(() => _addToCollection = val ?? false),
                title: Text('Add to Collection', style: AppTypography.bodyLg),
                subtitle: Text(
                  'Save as a favourite in your personal collection',
                  style: AppTypography.labelMdOutline(),
                ),
              ),

              const SizedBox(height: AppSpacing.stackGap),

              // ── Metadata (auto-filled / editable) ───────────────────────
              _label('Book Details  (auto-filled • editable)'),
              const SizedBox(height: 12),
              _field('Author', _authorCtrl, hint: 'e.g. J.K. Rowling'),
              _field('Cover Image URL', _coverCtrl, hint: 'https://...'),
              _field('Total Pages', _totalPagesCtrl, hint: 'e.g. 352', keyboard: TextInputType.number),
              _field('Genres', _genresCtrl, hint: 'Fiction, Fantasy'),
              _field('Language', _languageCtrl, hint: 'e.g. English'),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
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
    if (confirm == true && mounted) {
      final router = GoRouter.of(context);
      final canPop = router.canPop();
      await ref.read(bookListProvider.notifier).delete(widget.bookId!);
      if (mounted) {
        canPop ? router.pop() : router.go('/read');
      }
    }
  }

  Widget _label(String text) =>
      Text(text, style: AppTypography.labelMdVariant());

  Widget _field(String label, TextEditingController ctrl,
      {String? hint, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.stackGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboard,
            decoration: InputDecoration(hintText: hint),
            style: AppTypography.bodyLg,
          ),
        ],
      ),
    );
  }
}
