import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';

/// Abstract repository interface for learning paths.
abstract class LearningPathRepository {
  Future<List<LearningPath>> getAll();
  Future<LearningPath?> getById(String id);
  Future<LearningPath> add(LearningPath path);
  Future<LearningPath> update(LearningPath path);
  Future<void> delete(String id);
  Future<LearningPath> toggleStep(String pathId, String stepId);
}
