// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReminderItem _$ReminderItemFromJson(Map<String, dynamic> json) {
  return _ReminderItem.fromJson(json);
}

/// @nodoc
mixin _$ReminderItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  ReminderRecurrence get recurrence => throw _privateConstructorUsedError;
  String? get customDaysText => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReminderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReminderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderItemCopyWith<ReminderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderItemCopyWith<$Res> {
  factory $ReminderItemCopyWith(
    ReminderItem value,
    $Res Function(ReminderItem) then,
  ) = _$ReminderItemCopyWithImpl<$Res, ReminderItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    DateTime scheduledTime,
    ReminderRecurrence recurrence,
    String? customDaysText,
    bool isEnabled,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ReminderItemCopyWithImpl<$Res, $Val extends ReminderItem>
    implements $ReminderItemCopyWith<$Res> {
  _$ReminderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? scheduledTime = null,
    Object? recurrence = null,
    Object? customDaysText = freezed,
    Object? isEnabled = null,
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
            scheduledTime: null == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            recurrence: null == recurrence
                ? _value.recurrence
                : recurrence // ignore: cast_nullable_to_non_nullable
                      as ReminderRecurrence,
            customDaysText: freezed == customDaysText
                ? _value.customDaysText
                : customDaysText // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$ReminderItemImplCopyWith<$Res>
    implements $ReminderItemCopyWith<$Res> {
  factory _$$ReminderItemImplCopyWith(
    _$ReminderItemImpl value,
    $Res Function(_$ReminderItemImpl) then,
  ) = __$$ReminderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    DateTime scheduledTime,
    ReminderRecurrence recurrence,
    String? customDaysText,
    bool isEnabled,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ReminderItemImplCopyWithImpl<$Res>
    extends _$ReminderItemCopyWithImpl<$Res, _$ReminderItemImpl>
    implements _$$ReminderItemImplCopyWith<$Res> {
  __$$ReminderItemImplCopyWithImpl(
    _$ReminderItemImpl _value,
    $Res Function(_$ReminderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReminderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? scheduledTime = null,
    Object? recurrence = null,
    Object? customDaysText = freezed,
    Object? isEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ReminderItemImpl(
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
        scheduledTime: null == scheduledTime
            ? _value.scheduledTime
            : scheduledTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        recurrence: null == recurrence
            ? _value.recurrence
            : recurrence // ignore: cast_nullable_to_non_nullable
                  as ReminderRecurrence,
        customDaysText: freezed == customDaysText
            ? _value.customDaysText
            : customDaysText // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$ReminderItemImpl implements _ReminderItem {
  const _$ReminderItemImpl({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledTime,
    this.recurrence = ReminderRecurrence.none,
    this.customDaysText,
    this.isEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$ReminderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime scheduledTime;
  @override
  @JsonKey()
  final ReminderRecurrence recurrence;
  @override
  final String? customDaysText;
  @override
  @JsonKey()
  final bool isEnabled;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ReminderItem(id: $id, title: $title, description: $description, scheduledTime: $scheduledTime, recurrence: $recurrence, customDaysText: $customDaysText, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.customDaysText, customDaysText) ||
                other.customDaysText == customDaysText) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
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
    scheduledTime,
    recurrence,
    customDaysText,
    isEnabled,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ReminderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderItemImplCopyWith<_$ReminderItemImpl> get copyWith =>
      __$$ReminderItemImplCopyWithImpl<_$ReminderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderItemImplToJson(this);
  }
}

abstract class _ReminderItem implements ReminderItem {
  const factory _ReminderItem({
    required final String id,
    required final String title,
    final String? description,
    required final DateTime scheduledTime,
    final ReminderRecurrence recurrence,
    final String? customDaysText,
    final bool isEnabled,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ReminderItemImpl;

  factory _ReminderItem.fromJson(Map<String, dynamic> json) =
      _$ReminderItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get scheduledTime;
  @override
  ReminderRecurrence get recurrence;
  @override
  String? get customDaysText;
  @override
  bool get isEnabled;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ReminderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderItemImplCopyWith<_$ReminderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
