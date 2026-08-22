import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

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
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadItem());
    }
  }

  void _loadItem() {
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

    if (_isEdit) {
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
    if (mounted) context.pop();
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
          onPressed: () => context.go('/'),
        ),
        title: Text(_isEdit ? 'Edit ${widget.category.label}' : 'Add ${widget.category.label}',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _save, child: Text('Save', style: AppTypography.labelMdPrimary())),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          children: [
            _FormField(label: 'Title *', controller: _titleCtrl,
                validator: (v) => v!.isEmpty ? 'Required' : null),
            _FormField(label: 'Year', controller: _yearCtrl, keyboard: TextInputType.number),
            _FormField(label: 'Poster URL', controller: _posterUrlCtrl, hint: 'https://...'),
            _FormField(label: 'Genres', controller: _genresCtrl, hint: 'Sci-Fi, Drama'),
            _FormField(label: 'Language', controller: _languageCtrl),
            _FormField(label: 'Synopsis', controller: _synopsisCtrl, maxLines: 4),
            if (widget.category == MediaCategory.anime)
              _FormField(label: 'Total Episodes', controller: _totalEpsCtrl,
                  keyboard: TextInputType.number),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Status', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 8),
            DropdownButtonFormField<MediaStatus>(
              initialValue: _status,
              decoration: const InputDecoration(),
              onChanged: (s) => setState(() => _status = s!),
              items: MediaStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Rating', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(5, (i) {
                  final v = i + 1.0;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = _rating == v ? null : v),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        (_rating ?? 0) >= v ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: (_rating ?? 0) >= v ? AppColors.starAmber : AppColors.outlineVariant,
                        size: 32,
                      ),
                    ),
                  );
                }),
                if (_rating != null) ...[
                  const SizedBox(width: 8),
                  Text('${_rating!.toStringAsFixed(1)}', style: AppTypography.bodyLg),
                ],
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboard = TextInputType.text,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType keyboard;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.stackGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelMdVariant()),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(hintText: hint),
            style: AppTypography.bodyLg,
          ),
        ],
      ),
    );
  }
}
