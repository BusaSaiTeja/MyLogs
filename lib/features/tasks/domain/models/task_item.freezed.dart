// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) {
  return _TaskItem.fromJson(json);
}

/// @nodoc
mixin _$TaskItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaskItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskItemCopyWith<TaskItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskItemCopyWith<$Res> {
  factory $TaskItemCopyWith(TaskItem value, $Res Function(TaskItem) then) =
      _$TaskItemCopyWithImpl<$Res, TaskItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    bool isCompleted,
    TaskPriority priority,
    DateTime? dueDate,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TaskItemCopyWithImpl<$Res, $Val extends TaskItem>
    implements $TaskItemCopyWith<$Res> {
  _$TaskItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? workspaceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            workspaceId: null == workspaceId
                ? _value.workspaceId
                : workspaceId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskItemImplCopyWith<$Res>
    implements $TaskItemCopyWith<$Res> {
  factory _$$TaskItemImplCopyWith(
    _$TaskItemImpl value,
    $Res Function(_$TaskItemImpl) then,
  ) = __$$TaskItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    bool isCompleted,
    TaskPriority priority,
    DateTime? dueDate,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TaskItemImplCopyWithImpl<$Res>
    extends _$TaskItemCopyWithImpl<$Res, _$TaskItemImpl>
    implements _$$TaskItemImplCopyWith<$Res> {
  __$$TaskItemImplCopyWithImpl(
    _$TaskItemImpl _value,
    $Res Function(_$TaskItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? workspaceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TaskItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        workspaceId: null == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskItemImpl implements _TaskItem {
  const _$TaskItemImpl({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.workspaceId = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$TaskItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final TaskPriority priority;
  @override
  final DateTime? dueDate;
  @override
  @JsonKey()
  final String workspaceId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaskItem(id: $id, title: $title, description: $description, isCompleted: $isCompleted, priority: $priority, dueDate: $dueDate, workspaceId: $workspaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    isCompleted,
    priority,
    dueDate,
    workspaceId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskItemImplCopyWith<_$TaskItemImpl> get copyWith =>
      __$$TaskItemImplCopyWithImpl<_$TaskItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskItemImplToJson(this);
  }
}

abstract class _TaskItem implements TaskItem {
  const factory _TaskItem({
    required final String id,
    required final String title,
    final String? description,
    final bool isCompleted,
    final TaskPriority priority,
    final DateTime? dueDate,
    final String workspaceId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TaskItemImpl;

  factory _TaskItem.fromJson(Map<String, dynamic> json) =
      _$TaskItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  bool get isCompleted;
  @override
  TaskPriority get priority;
  @override
  DateTime? get dueDate;
  @override
  String get workspaceId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskItemImplCopyWith<_$TaskItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
