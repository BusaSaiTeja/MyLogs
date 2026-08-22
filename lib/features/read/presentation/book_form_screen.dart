import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

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

  BookStatus _status = BookStatus.toRead;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _authorCtrl = TextEditingController();
    _coverCtrl = TextEditingController();
    _totalPagesCtrl = TextEditingController();
    _genresCtrl = TextEditingController();
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
        setState(() => _status = book.status);
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _coverCtrl.dispose();
    _totalPagesCtrl.dispose();
    _genresCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final genres = _genresCtrl.text.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();
    final now = DateTime.now();

    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      if (_isEdit && widget.bookId != null) {
        final existing = ref.read(bookByIdProvider(widget.bookId!));
        if (existing == null) return;
        await ref.read(bookListProvider.notifier).updateItem(existing.copyWith(
              title: _titleCtrl.text.trim(),
              author: _authorCtrl.text.trim(),
              coverUrl: _coverCtrl.text.trim().isEmpty ? null : _coverCtrl.text.trim(),
              totalPages: int.tryParse(_totalPagesCtrl.text),
              genres: genres,
              status: _status,
              updatedAt: now,
            ));
      } else {
        await ref.read(bookListProvider.notifier).add(BookItem(
              id: '',
              title: _titleCtrl.text.trim(),
              author: _authorCtrl.text.trim(),
              coverUrl: _coverCtrl.text.trim().isEmpty ? null : _coverCtrl.text.trim(),
              totalPages: int.tryParse(_totalPagesCtrl.text),
              genres: genres,
              status: _status,
              createdAt: now,
              updatedAt: now,
            ));
      }
      if (!mounted) return;
      router.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to save book: $e')),
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
          onPressed: () => context.go('/'),
        ),
        title: Text(_isEdit ? 'Edit Book' : 'Add Book',
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
            _field('Title *', _titleCtrl, validator: (v) => v!.isEmpty ? 'Required' : null),
            _field('Author', _authorCtrl),
            _field('Cover URL', _coverCtrl, hint: 'https://...'),
            _field('Total Pages', _totalPagesCtrl, keyboard: TextInputType.number),
            _field('Genres', _genresCtrl, hint: 'Fiction, Fantasy'),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Status', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 6),
            DropdownButtonFormField<BookStatus>(
              initialValue: _status,
              decoration: const InputDecoration(),
              onChanged: (s) => setState(() => _status = s!),
              items: BookStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {String? hint, TextInputType keyboard = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.stackGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelMdVariant()),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboard,
            validator: validator,
            decoration: InputDecoration(hintText: hint),
            style: AppTypography.bodyLg,
          ),
        ],
      ),
    );
  }
}
