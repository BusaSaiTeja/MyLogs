import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/features/tasks/data/mock_task_repository.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/tasks/domain/task_repository.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return MockTaskRepository();
});

// ── Notifier ──────────────────────────────────────────────────────────────────
class TaskListNotifier extends AsyncNotifier<List<TaskItem>> {
  TaskRepository get _repo => ref.read(taskRepositoryProvider);

  @override
  Future<List<TaskItem>> build() async => _repo.getAll();

  Future<void> add(TaskItem item) async {
    final created = await _repo.add(item);
    state = AsyncData([...?state.valueOrNull, created]);
  }

  Future<void> updateItem(TaskItem item) async {
    final updated = await _repo.update(item);
    state = AsyncData(
      (state.valueOrNull ?? []).map((t) => t.id == updated.id ? updated : t).toList(),
    );
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = AsyncData((state.valueOrNull ?? []).where((t) => t.id != id).toList());
  }

  Future<void> toggleComplete(String id) async {
    final toggled = await _repo.toggleComplete(id);
    state = AsyncData(
      (state.valueOrNull ?? []).map((t) => t.id == toggled.id ? toggled : t).toList(),
    );
  }
}

final taskListProvider =
    AsyncNotifierProvider<TaskListNotifier, List<TaskItem>>(TaskListNotifier.new);

// ── Derived / Single-source views ─────────────────────────────────────────────

/// Today's incomplete tasks — single source of truth derived from taskListProvider.
final todayTasksProvider = Provider<List<TaskItem>>((ref) {
  final now = DateTime.now();
  return (ref.watch(taskListProvider).valueOrNull ?? []).where((t) {
    if (t.dueDate == null) return false;
    return t.dueDate!.year == now.year &&
        t.dueDate!.month == now.month &&
        t.dueDate!.day == now.day;
  }).toList()
    ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
});

/// Upcoming incomplete tasks (after today).
final upcomingTasksProvider = Provider<List<TaskItem>>((ref) {
  final now = DateTime.now();
  final sorted = (ref.watch(taskListProvider).valueOrNull ?? []).where((t) {
    if (t.dueDate == null) return false;
    return t.dueDate!.isAfter(now);
  }).toList()
    ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  return sorted;
});

/// All completed tasks.
final completedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  return tasks
      .where((t) => t.isCompleted)
      .toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
});

/// Today's task count — used on Home screen badge.
final todayTaskCountProvider = Provider<int>((ref) {
  return ref.watch(todayTasksProvider).length;
});
