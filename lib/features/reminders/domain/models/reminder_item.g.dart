// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderItemImpl _$$ReminderItemImplFromJson(Map<String, dynamic> json) =>
    _$ReminderItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      recurrence:
          $enumDecodeNullable(
            _$ReminderRecurrenceEnumMap,
            json['recurrence'],
          ) ??
          ReminderRecurrence.none,
      isEnabled: json['isEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReminderItemImplToJson(_$ReminderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'recurrence': _$ReminderRecurrenceEnumMap[instance.recurrence]!,
      'isEnabled': instance.isEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ReminderRecurrenceEnumMap = {
  ReminderRecurrence.none: 'none',
  ReminderRecurrence.daily: 'daily',
  ReminderRecurrence.weekly: 'weekly',
  ReminderRecurrence.monthly: 'monthly',
};
