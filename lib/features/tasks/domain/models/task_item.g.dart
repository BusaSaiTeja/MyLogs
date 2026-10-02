// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskItemImpl _$$TaskItemImplFromJson(Map<String, dynamic> json) =>
    _$TaskItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority:
          $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.medium,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      workspaceId: json['workspaceId'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskItemImplToJson(_$TaskItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'dueDate': instance.dueDate?.toIso8601String(),
      'workspaceId': instance.workspaceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};
