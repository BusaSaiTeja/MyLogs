import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.add(item);
      return _repo.getAll();
    });
  }

  Future<void> updateItem(TaskItem item) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.update(item);
      return _repo.getAll();
    });
  }

  Future<void> toggleComplete(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.toggleComplete(id);
      return _repo.getAll();
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.delete(id);
      return _repo.getAll();
    });
  }
}

final taskListProvider =
    AsyncNotifierProvider<TaskListNotifier, List<TaskItem>>(TaskListNotifier.new);

// ── Derived Providers ────────────────────────────────────────────────────────
final todayTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return tasks
      .where((t) =>
          !t.isCompleted &&
          t.dueDate != null &&
          t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day)
      .toList();
});

final upcomingTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  final today = DateTime.now();
  final startOfTomorrow = DateTime(today.year, today.month, today.day + 1);
  return tasks
      .where((t) =>
          !t.isCompleted &&
          (t.dueDate == null || t.dueDate!.isAfter(startOfTomorrow) || t.dueDate!.isAtSameMomentAs(startOfTomorrow)))
      .toList();
});

final completedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  return tasks.where((t) => t.isCompleted).toList();
});
