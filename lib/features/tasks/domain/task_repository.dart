import 'package:my_logs/features/tasks/domain/models/task_item.dart';

/// Abstract repository interface for tasks.
abstract class TaskRepository {
  Future<List<TaskItem>> getAll();
  Future<TaskItem?> getById(String id);
  Future<TaskItem> add(TaskItem item);
  Future<TaskItem> update(TaskItem item);
  Future<void> delete(String id);
  Future<TaskItem> toggleComplete(String id);
}
