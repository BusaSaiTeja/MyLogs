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

int _priorityWeight(TaskPriority p) => switch (p) {
      TaskPriority.high => 0,
      TaskPriority.medium => 1,
      TaskPriority.low => 2,
    };

// ── Derived Providers ────────────────────────────────────────────────────────
// Today's tasks sorted by priority (High -> Med -> Low)
final todayTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final list = tasks
      .where((t) =>
          !t.isCompleted &&
          t.dueDate != null &&
          t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day)
      .toList();

  list.sort((a, b) => _priorityWeight(a.priority).compareTo(_priorityWeight(b.priority)));
  return list;
});

// Upcoming tasks sorted by date (earliest to latest)
final upcomingTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  final today = DateTime.now();
  final startOfTomorrow = DateTime(today.year, today.month, today.day + 1);
  final list = tasks
      .where((t) =>
          !t.isCompleted &&
          (t.dueDate == null ||
              t.dueDate!.isAfter(startOfTomorrow) ||
              t.dueDate!.isAtSameMomentAs(startOfTomorrow)))
      .toList();

  list.sort((a, b) {
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
  });
  return list;
});

// Completed tasks
final completedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  return tasks.where((t) => t.isCompleted).toList();
});

// Missed / Overdue tasks
final missedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(taskListProvider).valueOrNull ?? [];
  final today = DateTime.now();
  final startOfToday = DateTime(today.year, today.month, today.day);
  final list = tasks
      .where((t) =>
          !t.isCompleted &&
          t.dueDate != null &&
          t.dueDate!.isBefore(startOfToday))
      .toList();

  list.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  return list;
});
