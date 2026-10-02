import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_item.freezed.dart';
part 'note_item.g.dart';

@freezed
class NoteItem with _$NoteItem {
  const factory NoteItem({
    required String id,
    required String title,
    required String content,
    @Default([]) List<String> tags,
    @Default('') String workspaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NoteItem;

  factory NoteItem.fromJson(Map<String, dynamic> json) => _$NoteItemFromJson(json);
}
