import 'package:uuid/uuid.dart';
import 'package:my_logs/features/read/domain/book_repository.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';

/// In-memory mock implementation of [BookRepository].
class MockBookRepository implements BookRepository {
  MockBookRepository() {
    _items = List.from(_seed);
  }

  static const _uuid = Uuid();
  late List<BookItem> _items;

  static final List<BookItem> _seed = [
    BookItem(
      id: 'book-1',
      title: 'Atomic Habits',
      author: 'James Clear',
      status: BookStatus.reading,
      rating: 4.5,
      coverUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=300',
      totalPages: 320,
      currentPage: 198,
      genres: ['Self-Help', 'Productivity'],
      notes: 'The 1% rule is life-changing.',
      createdAt: DateTime(2024, 7, 1),
      updatedAt: DateTime(2024, 8, 20),
    ),
    BookItem(
      id: 'book-2',
      title: 'Thinking, Fast and Slow',
      author: 'Daniel Kahneman',
      status: BookStatus.reading,
      rating: 4.0,
      coverUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300',
      totalPages: 499,
      currentPage: 225,
      genres: ['Psychology', 'Behavioral Economics'],
      createdAt: DateTime(2024, 6, 10),
      updatedAt: DateTime(2024, 8, 15),
    ),
    BookItem(
      id: 'book-3',
      title: 'Dune',
      author: 'Frank Herbert',
      status: BookStatus.read,
      rating: 5.0,
      coverUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300',
      totalPages: 896,
      currentPage: 896,
      genres: ['Sci-Fi', 'Epic Fantasy'],
      notes: 'The greatest sci-fi novel ever written.',
      createdAt: DateTime(2023, 9, 1),
      updatedAt: DateTime(2023, 12, 15),
    ),
    BookItem(
      id: 'book-4',
      title: 'The Design of Everyday Things',
      author: 'Don Norman',
      status: BookStatus.toRead,
      coverUrl: 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=300',
      totalPages: 368,
      currentPage: 0,
      genres: ['Design', 'UX'],
      createdAt: DateTime(2024, 8, 5),
      updatedAt: DateTime(2024, 8, 5),
    ),
    BookItem(
      id: 'book-5',
      title: 'Deep Work',
      author: 'Cal Newport',
      status: BookStatus.reading,
      rating: 4.5,
      coverUrl: 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=300',
      totalPages: 296,
      currentPage: 120,
      genres: ['Focus', 'Productivity'],
      createdAt: DateTime(2024, 5, 15),
      updatedAt: DateTime(2024, 8, 10),
    ),
    BookItem(
      id: 'book-6',
      title: 'Red Mars',
      author: 'Kim Stanley Robinson',
      status: BookStatus.reading,
      coverUrl: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=300',
      totalPages: 572,
      currentPage: 68,
      genres: ['Sci-Fi', 'Hard SF'],
      createdAt: DateTime(2024, 8, 1),
      updatedAt: DateTime(2024, 8, 18),
    ),
    BookItem(
      id: 'book-7',
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      status: BookStatus.read,
      rating: 5.0,
      coverUrl: 'https://images.unsplash.com/photo-1484589065579-248aad0d8b13?w=300',
      totalPages: 476,
      currentPage: 476,
      genres: ['Sci-Fi', 'Adventure'],
      notes: 'Rocky is the best character in recent fiction.',
      createdAt: DateTime(2024, 2, 1),
      updatedAt: DateTime(2024, 3, 10),
    ),
    BookItem(
      id: 'book-8',
      title: 'The Pragmatic Programmer',
      author: 'David Thomas, Andrew Hunt',
      status: BookStatus.collection,
      rating: 4.5,
      coverUrl: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=300',
      totalPages: 352,
      currentPage: 352,
      genres: ['Programming', 'Software Engineering'],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 6, 15),
    ),
  ];

  @override
  Future<List<BookItem>> getAll() async => List.unmodifiable(_items);

  @override
  Future<List<BookItem>> getByStatus(BookStatus status) async =>
      _items.where((b) => b.status == status).toList();

  @override
  Future<BookItem?> getById(String id) async =>
      _items.where((b) => b.id == id).firstOrNull;

  @override
  Future<BookItem> add(BookItem item) async {
    final newItem = item.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.add(newItem);
    return newItem;
  }

  @override
  Future<BookItem> update(BookItem item) async {
    final idx = _items.indexWhere((b) => b.id == item.id);
    if (idx == -1) throw Exception('BookItem not found: ${item.id}');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _items[idx] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((b) => b.id == id);
  }

  @override
  Future<List<BookItem>> getCurrentlyReading({int limit = 5}) async {
    final reading = _items
        .where((b) => b.status == BookStatus.reading)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return reading.take(limit).toList();
  }
}
