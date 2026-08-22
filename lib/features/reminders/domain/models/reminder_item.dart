import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_item.freezed.dart';
part 'reminder_item.g.dart';

enum ReminderRecurrence { none, daily, weekly, monthly }

extension ReminderRecurrenceExt on ReminderRecurrence {
  String get label {
    switch (this) {
      case ReminderRecurrence.none: return 'None';
      case ReminderRecurrence.daily: return 'Daily';
      case ReminderRecurrence.weekly: return 'Weekly';
      case ReminderRecurrence.monthly: return 'Monthly';
    }
  }
}

@freezed
class ReminderItem with _$ReminderItem {
  const factory ReminderItem({
    required String id,
    required String title,
    String? description,
    required DateTime scheduledTime,
    @Default(ReminderRecurrence.none) ReminderRecurrence recurrence,
    @Default(true) bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReminderItem;

  factory ReminderItem.fromJson(Map<String, dynamic> json) => _$ReminderItemFromJson(json);
}
