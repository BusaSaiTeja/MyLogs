// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceItemImpl _$$WorkspaceItemImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String? ?? 'person_outline_rounded',
      colorValue: (json['colorValue'] as num?)?.toInt() ?? 0xFF4F46E5,
      isDefault: json['isDefault'] as bool? ?? false,
      enabledFeatures:
          (json['enabledFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [
            'notes',
            'tasks',
            'reminders',
            'read',
            'watch',
            'learning_paths',
          ],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkspaceItemImplToJson(_$WorkspaceItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'isDefault': instance.isDefault,
      'enabledFeatures': instance.enabledFeatures,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
