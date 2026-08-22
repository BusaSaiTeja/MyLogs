import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/core/utils/date_utils.dart';
import 'package:my_logs/core/utils/notification_service.dart';
import 'package:my_logs/features/reminders/data/mock_reminder_repository.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';
import 'package:my_logs/features/reminders/domain/reminder_repository.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return MockReminderRepository();
});

// ── Notifier ──────────────────────────────────────────────────────────────────
class ReminderListNotifier extends AsyncNotifier<List<ReminderItem>> {
  ReminderRepository get _repo => ref.read(reminderRepositoryProvider);

  @override
  Future<List<ReminderItem>> build() async => _repo.getAll();

  Future<void> add(ReminderItem item) async {
    final created = await _repo.add(item);
    if (created.isEnabled) {
      await _scheduleNotification(created);
    }
    state = AsyncData([...?state.valueOrNull, created]);
  }

  Future<void> updateItem(ReminderItem item) async {
    final updated = await _repo.update(item);
    // Cancel old and reschedule if enabled
    await NotificationService.instance.cancelNotification(
      NotificationService.idFromString(updated.id),
    );
    if (updated.isEnabled) await _scheduleNotification(updated);
    state = AsyncData(
      (state.valueOrNull ?? []).map((r) => r.id == updated.id ? updated : r).toList(),
    );
  }

  Future<void> delete(String id) async {
    await NotificationService.instance.cancelNotification(
      NotificationService.idFromString(id),
    );
    await _repo.delete(id);
    state = AsyncData((state.valueOrNull ?? []).where((r) => r.id != id).toList());
  }

  /// Toggles enabled state and schedules / cancels the notification accordingly.
  Future<void> toggle(String id) async {
    final toggled = await _repo.toggleEnabled(id);
    if (toggled.isEnabled) {
      await _scheduleNotification(toggled);
    } else {
      await NotificationService.instance.cancelNotification(
        NotificationService.idFromString(toggled.id),
      );
    }
    state = AsyncData(
      (state.valueOrNull ?? []).map((r) => r.id == toggled.id ? toggled : r).toList(),
    );
  }

  Future<void> _scheduleNotification(ReminderItem item) async {
    await NotificationService.instance.scheduleNotification(
      id: NotificationService.idFromString(item.id),
      title: 'MyLog Reminder',
      body: item.title,
      scheduledTime: item.scheduledTime,
    );
  }
}

final reminderListProvider =
    AsyncNotifierProvider<ReminderListNotifier, List<ReminderItem>>(
  ReminderListNotifier.new,
);

// ── Derived Providers ─────────────────────────────────────────────────────────
final todayRemindersProvider = Provider<List<ReminderItem>>((ref) {
  final reminders = ref.watch(reminderListProvider).valueOrNull ?? [];
  return reminders.where((r) => r.isEnabled && AppDateUtils.isToday(r.scheduledTime)).toList()
    ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
});
