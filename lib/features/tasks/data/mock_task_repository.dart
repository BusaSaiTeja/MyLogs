import 'package:uuid/uuid.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/tasks/domain/task_repository.dart';

/// In-memory mock implementation of [TaskRepository].
class MockTaskRepository implements TaskRepository {
  MockTaskRepository() {
    _items = List.from(_seed);
  }

  static const _uuid = Uuid();
  late List<TaskItem> _items;

  static final _now = DateTime.now();
  static final _today = DateTime(_now.year, _now.month, _now.day);
  static final _tomorrow = _today.add(const Duration(days: 1));
  static final _friday = _today.add(Duration(days: (5 - _today.weekday + 7) % 7 + 1));

  static final List<TaskItem> _seed = [
    // Today tasks
    TaskItem(
      id: 'task-1',
      title: 'Morning Meditation & Journaling',
      priority: TaskPriority.high,
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      createdAt: _today,
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-2',
      title: 'Review Weekly Goals',
      description: 'Check progress against this week\'s OKRs',
      priority: TaskPriority.medium,
      dueDate: DateTime.now().add(const Duration(hours: 4)),
      createdAt: DateTime.now(),
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-3',
      title: 'Read 30 pages of new book',
      priority: TaskPriority.low,
      dueDate: _today,
      createdAt: _today,
      updatedAt: _today,
    ),
    // Upcoming tasks
    TaskItem(
      id: 'task-4',
      title: 'Grocery Shopping',
      description: 'Milk, eggs, bread, coffee, avocados',
      priority: TaskPriority.medium,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-5',
      title: 'Schedule Dentist Appointment',
      priority: TaskPriority.low,
      dueDate: _friday,
      createdAt: _today,
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-6',
      title: 'Prepare Presentation Deck',
      description: 'Include the new analytics charts and Q4 projections',
      priority: TaskPriority.high,
      dueDate: _tomorrow,
      createdAt: _today,
      updatedAt: _today,
    ),
    // Completed tasks
    TaskItem(
      id: 'task-7',
      title: 'Drink 2L Water',
      priority: TaskPriority.low,
      isCompleted: true,
      dueDate: _today,
      createdAt: _today,
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-8',
      title: 'Reply to Emails',
      priority: TaskPriority.medium,
      isCompleted: true,
      dueDate: _today,
      createdAt: _today,
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-9',
      title: 'Review Q3 Design Spec',
      priority: TaskPriority.high,
      isCompleted: true,
      dueDate: _today,
      createdAt: _today.subtract(const Duration(days: 1)),
      updatedAt: _today,
    ),
    TaskItem(
      id: 'task-10',
      title: 'Call dentist for appointment',
      priority: TaskPriority.high,
      isCompleted: true,
      dueDate: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: _today,
    ),
  ];

  @override
  Future<List<TaskItem>> getAll() async => List.unmodifiable(_items);

  @override
  Future<TaskItem?> getById(String id) async =>
      _items.where((t) => t.id == id).firstOrNull;

  @override
  Future<TaskItem> add(TaskItem item) async {
    final newItem = item.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.add(newItem);
    return newItem;
  }

  @override
  Future<TaskItem> update(TaskItem item) async {
    final idx = _items.indexWhere((t) => t.id == item.id);
    if (idx == -1) throw Exception('TaskItem not found: ${item.id}');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _items[idx] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((t) => t.id == id);
  }

  @override
  Future<TaskItem> toggleComplete(String id) async {
    final idx = _items.indexWhere((t) => t.id == id);
    if (idx == -1) throw Exception('TaskItem not found: $id');
    final toggled = _items[idx].copyWith(
      isCompleted: !_items[idx].isCompleted,
      updatedAt: DateTime.now(),
    );
    _items[idx] = toggled;
    return toggled;
  }
}
