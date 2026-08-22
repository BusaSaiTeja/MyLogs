import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/features/learning_paths/data/mock_learning_path_repository.dart';
import 'package:my_logs/features/learning_paths/domain/learning_path_repository.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
final learningPathRepositoryProvider = Provider<LearningPathRepository>((ref) {
  return MockLearningPathRepository();
});

// ── Notifier ──────────────────────────────────────────────────────────────────
class LearningPathListNotifier extends AsyncNotifier<List<LearningPath>> {
  LearningPathRepository get _repo => ref.read(learningPathRepositoryProvider);

  @override
  Future<List<LearningPath>> build() async => _repo.getAll();

  Future<void> add(LearningPath path) async {
    final created = await _repo.add(path);
    state = AsyncData([...?state.valueOrNull, created]);
  }

  Future<void> updateItem(LearningPath path) async {
    final updated = await _repo.update(path);
    state = AsyncData(
      (state.valueOrNull ?? []).map((p) => p.id == updated.id ? updated : p).toList(),
    );
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = AsyncData((state.valueOrNull ?? []).where((p) => p.id != id).toList());
  }

  /// Toggle a single step's completion — progress % is re-computed automatically.
  Future<void> toggleStep(String pathId, String stepId) async {
    final updated = await _repo.toggleStep(pathId, stepId);
    state = AsyncData(
      (state.valueOrNull ?? []).map((p) => p.id == updated.id ? updated : p).toList(),
    );
  }
}

final learningPathListProvider =
    AsyncNotifierProvider<LearningPathListNotifier, List<LearningPath>>(
  LearningPathListNotifier.new,
);

final learningPathByIdProvider =
    Provider.family<LearningPath?, String>((ref, id) {
  return ref
      .watch(learningPathListProvider)
      .valueOrNull
      ?.where((p) => p.id == id)
      .firstOrNull;
});

/// Computed progress for a path (0.0 – 1.0) — never stored, always derived.
final pathProgressProvider = Provider.family<double, String>((ref, pathId) {
  final path = ref.watch(learningPathByIdProvider(pathId));
  if (path == null || path.steps.isEmpty) return 0.0;
  final completed = path.steps.where((s) => s.isCompleted).length;
  return completed / path.steps.length;
});

/// Computed status label from progress — never stored.
final pathStatusProvider = Provider.family<String, String>((ref, pathId) {
  final progress = ref.watch(pathProgressProvider(pathId));
  if (progress <= 0.0) return 'Not Started';
  if (progress >= 1.0) return 'Completed';
  return 'In Progress';
});
