import 'package:uuid/uuid.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';
import 'package:my_logs/features/reminders/domain/reminder_repository.dart';
import 'package:my_logs/core/utils/date_utils.dart';

/// In-memory mock implementation of [ReminderRepository].
class MockReminderRepository implements ReminderRepository {
  MockReminderRepository() {
    _items = List.from(_seed);
  }

  static const _uuid = Uuid();
  late List<ReminderItem> _items;

  static final _now = DateTime.now();
  static DateTime _todayAt(int hour, int minute) =>
      DateTime(_now.year, _now.month, _now.day, hour, minute);

  static final List<ReminderItem> _seed = [
    ReminderItem(
      id: 'rem-1',
      title: 'Morning Briefing',
      scheduledTime: _todayAt(9, 0),
      isEnabled: true,
      recurrence: ReminderRecurrence.daily,
      createdAt: DateTime(2024, 7, 1),
      updatedAt: DateTime(2024, 7, 1),
    ),
    ReminderItem(
      id: 'rem-2',
      title: 'Evening Reflection',
      scheduledTime: _todayAt(20, 30),
      isEnabled: false,
      recurrence: ReminderRecurrence.daily,
      createdAt: DateTime(2024, 7, 1),
      updatedAt: DateTime(2024, 8, 1),
    ),
    ReminderItem(
      id: 'rem-3',
      title: 'Team Standup',
      scheduledTime: _todayAt(10, 0),
      isEnabled: true,
      recurrence: ReminderRecurrence.daily,
      createdAt: DateTime(2024, 8, 5),
      updatedAt: DateTime(2024, 8, 5),
    ),
    ReminderItem(
      id: 'rem-4',
      title: 'Water the Plants',
      scheduledTime: _todayAt(18, 0),
      isEnabled: true,
      recurrence: ReminderRecurrence.weekly,
      createdAt: DateTime(2024, 8, 10),
      updatedAt: DateTime(2024, 8, 10),
    ),
    ReminderItem(
      id: 'rem-5',
      title: 'Weekly Review',
      scheduledTime: DateTime(_now.year, _now.month, _now.day + (7 - _now.weekday), 16, 0),
      isEnabled: true,
      recurrence: ReminderRecurrence.weekly,
      createdAt: DateTime(2024, 8, 15),
      updatedAt: DateTime(2024, 8, 15),
    ),
  ];

  @override
  Future<List<ReminderItem>> getAll() async => List.unmodifiable(_items);

  @override
  Future<ReminderItem?> getById(String id) async =>
      _items.where((r) => r.id == id).firstOrNull;

  @override
  Future<ReminderItem> add(ReminderItem item) async {
    final newItem = item.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.add(newItem);
    return newItem;
  }

  @override
  Future<ReminderItem> update(ReminderItem item) async {
    final idx = _items.indexWhere((r) => r.id == item.id);
    if (idx == -1) throw Exception('ReminderItem not found: ${item.id}');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _items[idx] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((r) => r.id == id);
  }

  @override
  Future<ReminderItem> toggleEnabled(String id) async {
    final idx = _items.indexWhere((r) => r.id == id);
    if (idx == -1) throw Exception('ReminderItem not found: $id');
    final toggled = _items[idx].copyWith(
      isEnabled: !_items[idx].isEnabled,
      updatedAt: DateTime.now(),
    );
    _items[idx] = toggled;
    return toggled;
  }

  @override
  Future<List<ReminderItem>> getTodayReminders() async {
    return _items.where((r) => r.isEnabled && AppDateUtils.isToday(r.scheduledTime)).toList();
  }
}
