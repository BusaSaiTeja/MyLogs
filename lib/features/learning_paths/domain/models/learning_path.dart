import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_logs/core/domain/workspace_scoped.dart';

part 'learning_path.freezed.dart';
part 'learning_path.g.dart';

@freezed
class PathStep with _$PathStep {
  const factory PathStep({
    required String id,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
    int? order,
    String? resourceUrl,
  }) = _PathStep;

  factory PathStep.fromJson(Map<String, dynamic> json) => _$PathStepFromJson(json);
}

@freezed
class LearningPath with _$LearningPath implements WorkspaceScoped {
  const factory LearningPath({
    required String id,
    required String title,
    String? description,
    @Default([]) List<PathStep> steps,
    @Default('') String workspaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LearningPath;

  factory LearningPath.fromJson(Map<String, dynamic> json) => _$LearningPathFromJson(json);
}
