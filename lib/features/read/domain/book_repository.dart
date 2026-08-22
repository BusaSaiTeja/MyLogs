import 'package:my_logs/features/read/domain/models/book_item.dart';

/// Abstract repository interface for books.
abstract class BookRepository {
  Future<List<BookItem>> getAll();
  Future<List<BookItem>> getByStatus(BookStatus status);
  Future<BookItem?> getById(String id);
  Future<BookItem> add(BookItem item);
  Future<BookItem> update(BookItem item);
  Future<void> delete(String id);

  /// Returns items with status == reading, ordered by updatedAt desc.
  Future<List<BookItem>> getCurrentlyReading({int limit = 5});
}
