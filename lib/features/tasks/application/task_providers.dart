import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/tasks/data/firestore_task_repository.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/tasks/domain/task_repository.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return FirestoreTaskRepository(authService: authService);
});

// ── Notifier ──────────────────────────────────────────────────────────────────
class TaskListNotifier extends AsyncNotifier<List<TaskItem>> {
  TaskRepository get _repo => ref.read(taskRepositoryProvider);

  @override
  Future<List<TaskItem>> build() async => _repo.getAll();

  /// Optimistically adds a task instantly without waiting for extra network roundtrips.
  Future<void> add(TaskItem item) async {
    final current = state.valueOrNull ?? [];
    final tempId = item.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : item.id;
    final optimisticItem = item.copyWith(id: tempId);
    state = AsyncData([optimisticItem, ...current]);

    try {
      final savedItem = await _repo.add(item);
      final updatedList = (state.valueOrNull ?? []).map((t) => t.id == tempId ? savedItem : t).toList();
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(current);
      rethrow;
    }
  }

  /// Optimistically updates a task locally and syncs to database.
  Future<void> updateItem(TaskItem item) async {
    final current = state.valueOrNull ?? [];
    final previous = current;
    state = AsyncData(current.map((t) => t.id == item.id ? item : t).toList());

    try {
      await _repo.update(item);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Optimistically toggles task completion instantly.
  Future<void> toggleComplete(String id) async {
    final current = state.valueOrNull ?? [];
    final previous = current;
    final now = DateTime.now();

    state = AsyncData(current.map((t) {
      if (t.id == id) {
        return t.copyWith(
          isCompleted: !t.isCompleted,
          updatedAt: now,
        );
      }
      return t;
    }).toList());

    try {
      await _repo.toggleComplete(id);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Optimistically deletes a task instantly.
  Future<void> delete(String id) async {
    final current = state.valueOrNull ?? [];
    final previous = current;
    state = AsyncData(current.where((t) => t.id != id).toList());

    try {
      await _repo.delete(id);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
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

// Today's tasks
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

// Upcoming tasks (Future dates or tasks without a date)
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
    if (a.dueDate != null && b.dueDate != null) {
      final cmp = a.dueDate!.compareTo(b.dueDate!);
      if (cmp != 0) return cmp;
    } else if (a.dueDate != null && b.dueDate == null) {
      return -1;
    } else if (a.dueDate == null && b.dueDate != null) {
      return 1;
    }
    return _priorityWeight(a.priority).compareTo(_priorityWeight(b.priority));
  });
  return list;
});

// Pending tasks (Today + Upcoming)
final pendingTasksProvider = Provider<List<TaskItem>>((ref) {
  final today = ref.watch(todayTasksProvider);
  final upcoming = ref.watch(upcomingTasksProvider);
  return [...today, ...upcoming];
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
