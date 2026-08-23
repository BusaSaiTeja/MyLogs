import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/watch/presentation/widgets/media_rating_selector.dart';

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

  MediaStatus _status = MediaStatus.planToWatch;
  double? _rating;
  bool _isEdit = false;

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
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    _synopsisCtrl.dispose();
    _genresCtrl.dispose();
    _languageCtrl.dispose();
    _posterUrlCtrl.dispose();
    _totalEpsCtrl.dispose();
    super.dispose();
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
        await ref.read(mediaListProvider.notifier).add(
              MediaItem(
                id: '',
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
        title: Text(_isEdit ? 'Edit ${widget.category.label}' : 'Add ${widget.category.label}',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          if (_isEdit && widget.itemId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.error,
              onPressed: () async {
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
                if (confirm == true && context.mounted) {
                  await ref.read(mediaListProvider.notifier).delete(widget.itemId!);
                  if (context.mounted) {
                    context.canPop() ? context.pop() : context.go('/watch');
                  }
                }
              },
            ),
          TextButton(onPressed: _save, child: Text('Save', style: AppTypography.labelMdPrimary())),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          children: [
            _field('Title *', _titleCtrl, required: true, hint: 'e.g. Inception'),
            const SizedBox(height: AppSpacing.stackGap),
            if (widget.category == MediaCategory.anime) ...[
              _field('Total Episodes', _totalEpsCtrl,
                  hint: 'e.g. 24', keyboard: TextInputType.number),
              const SizedBox(height: AppSpacing.stackGap),
            ],
            _field('Year', _yearCtrl, hint: 'e.g. 2010', keyboard: TextInputType.number),
            const SizedBox(height: AppSpacing.stackGap),
            _field('Language', _languageCtrl, hint: 'e.g. English, Japanese'),
            const SizedBox(height: AppSpacing.stackGap),
            _field('Genres (comma-separated)', _genresCtrl, hint: 'Sci-Fi, Action, Thriller'),
            const SizedBox(height: AppSpacing.stackGap),
            _field('Poster Image URL', _posterUrlCtrl,
                hint: 'https://...', keyboard: TextInputType.url),
            const SizedBox(height: AppSpacing.stackGap),
            _label('Status'),
            const SizedBox(height: 6),
            DropdownButtonFormField<MediaStatus>(
              initialValue: _status,
              decoration: const InputDecoration(),
              onChanged: (s) {
                if (s != null) setState(() => _status = s);
              },
              items: MediaStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            _label('Rating (1 - 10)'),
            const SizedBox(height: 8),
            MediaRatingSelector(
              rating: _rating,
              onRatingChanged: (r) => setState(() => _rating = r),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            _field('Synopsis', _synopsisCtrl, maxLines: 4, hint: 'Short overview...'),
            const SizedBox(height: 32),
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          validator: required ? (v) => v!.trim().isEmpty ? 'Required' : null : null,
          decoration: InputDecoration(hintText: hint),
          style: AppTypography.bodyLg,
        ),
      ],
    );
  }
}
