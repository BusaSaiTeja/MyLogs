import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_item.freezed.dart';
part 'workspace_item.g.dart';

@freezed
class WorkspaceItem with _$WorkspaceItem {
  const factory WorkspaceItem({
    required String id,
    required String name,
    @Default('person_outline_rounded') String iconName,
    @Default(0xFF4F46E5) int colorValue,
    @Default(false) bool isDefault,
    @Default(['notes', 'tasks', 'reminders', 'read', 'watch', 'learning_paths'])
    List<String> enabledFeatures,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkspaceItem;

  factory WorkspaceItem.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceItemFromJson(json);
}
