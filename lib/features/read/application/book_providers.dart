import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/features/read/data/google_books_service.dart';
import 'package:my_logs/features/read/data/mock_book_repository.dart';
import 'package:my_logs/features/read/domain/book_repository.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return MockBookRepository();
});

final googleBooksServiceProvider = Provider<GoogleBooksService>((ref) {
  return GoogleBooksService();
});

// ── Notifier ──────────────────────────────────────────────────────────────────
class BookListNotifier extends AsyncNotifier<List<BookItem>> {
  BookRepository get _repo => ref.read(bookRepositoryProvider);

  @override
  Future<List<BookItem>> build() async => _repo.getAll();

  Future<void> add(BookItem item) async {
    final created = await _repo.add(item);
    state = AsyncData([...?state.valueOrNull, created]);
  }

  Future<void> updateItem(BookItem item) async {
    final updated = await _repo.update(item);
    state = AsyncData(
      (state.valueOrNull ?? []).map((b) => b.id == updated.id ? updated : b).toList(),
    );
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = AsyncData((state.valueOrNull ?? []).where((b) => b.id != id).toList());
  }

  Future<void> updateStatus(String id, BookStatus status) async {
    final existing = (state.valueOrNull ?? []).firstWhere((b) => b.id == id);
    await updateItem(existing.copyWith(status: status));
  }

  Future<void> updateProgress(String id, int currentPage) async {
    final existing = (state.valueOrNull ?? []).firstWhere((b) => b.id == id);
    await updateItem(existing.copyWith(currentPage: currentPage));
  }

  Future<void> updateRating(String id, double rating) async {
    final existing = (state.valueOrNull ?? []).firstWhere((b) => b.id == id);
    await updateItem(existing.copyWith(rating: rating));
  }

  Future<void> updateNotes(String id, String notes) async {
    final existing = (state.valueOrNull ?? []).firstWhere((b) => b.id == id);
    await updateItem(existing.copyWith(notes: notes));
  }
}

final bookListProvider =
    AsyncNotifierProvider<BookListNotifier, List<BookItem>>(BookListNotifier.new);

// ── Derived Providers ─────────────────────────────────────────────────────────
final booksByStatusProvider =
    Provider.family<List<BookItem>, BookStatus>((ref, status) {
  return ref.watch(bookListProvider).valueOrNull?.where((b) => b.status == status).toList() ?? [];
});

final bookByIdProvider = Provider.family<BookItem?, String>((ref, id) {
  return ref.watch(bookListProvider).valueOrNull?.where((b) => b.id == id).firstOrNull;
});

final currentlyReadingProvider = Provider<List<BookItem>>((ref) {
  final books = ref.watch(bookListProvider).valueOrNull ?? [];
  return (books.where((b) => b.status == BookStatus.reading).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)))
      .take(5)
      .toList();
});
