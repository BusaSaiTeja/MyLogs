import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';

/// Abstract repository interface for reminders.
abstract class ReminderRepository {
  Future<List<ReminderItem>> getAll();
  Future<ReminderItem?> getById(String id);
  Future<ReminderItem> add(ReminderItem item);
  Future<ReminderItem> update(ReminderItem item);
  Future<void> delete(String id);
  Future<ReminderItem> toggleEnabled(String id);

  /// Returns all enabled reminders scheduled for today.
  Future<List<ReminderItem>> getTodayReminders();
}
