import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_item.freezed.dart';
part 'book_item.g.dart';

enum BookStatus { toRead, reading, read, onHold, dropped, collection }

extension BookStatusExt on BookStatus {
  String get label {
    switch (this) {
      case BookStatus.toRead: return 'To Read';
      case BookStatus.reading: return 'Reading';
      case BookStatus.read: return 'Read';
      case BookStatus.onHold: return 'On Hold';
      case BookStatus.dropped: return 'Dropped';
      case BookStatus.collection: return 'Collection';
    }
  }
}

@freezed
class BookItem with _$BookItem {
  const factory BookItem({
    required String id,
    required String title,
    required String author,
    @Default(BookStatus.toRead) BookStatus status,
    @Default(false) bool isCollection,
    String? coverUrl,
    String? synopsis,
    @Default([]) List<String> genres,
    double? rating,
    @Default(0) int currentPage,
    int? totalPages,
    String? notes,
    @Default('') String workspaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BookItem;

  factory BookItem.fromJson(Map<String, dynamic> json) => _$BookItemFromJson(json);
}
