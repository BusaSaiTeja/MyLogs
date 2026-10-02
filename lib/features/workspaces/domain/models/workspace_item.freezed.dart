// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkspaceItem _$WorkspaceItemFromJson(Map<String, dynamic> json) {
  return _WorkspaceItem.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  int get colorValue => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  List<String> get enabledFeatures => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceItemCopyWith<WorkspaceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceItemCopyWith<$Res> {
  factory $WorkspaceItemCopyWith(
    WorkspaceItem value,
    $Res Function(WorkspaceItem) then,
  ) = _$WorkspaceItemCopyWithImpl<$Res, WorkspaceItem>;
  @useResult
  $Res call({
    String id,
    String name,
    String iconName,
    int colorValue,
    bool isDefault,
    List<String> enabledFeatures,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$WorkspaceItemCopyWithImpl<$Res, $Val extends WorkspaceItem>
    implements $WorkspaceItemCopyWith<$Res> {
  _$WorkspaceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconName = null,
    Object? colorValue = null,
    Object? isDefault = null,
    Object? enabledFeatures = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            iconName: null == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String,
            colorValue: null == colorValue
                ? _value.colorValue
                : colorValue // ignore: cast_nullable_to_non_nullable
                      as int,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            enabledFeatures: null == enabledFeatures
                ? _value.enabledFeatures
                : enabledFeatures // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$WorkspaceItemImplCopyWith<$Res>
    implements $WorkspaceItemCopyWith<$Res> {
  factory _$$WorkspaceItemImplCopyWith(
    _$WorkspaceItemImpl value,
    $Res Function(_$WorkspaceItemImpl) then,
  ) = __$$WorkspaceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String iconName,
    int colorValue,
    bool isDefault,
    List<String> enabledFeatures,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$WorkspaceItemImplCopyWithImpl<$Res>
    extends _$WorkspaceItemCopyWithImpl<$Res, _$WorkspaceItemImpl>
    implements _$$WorkspaceItemImplCopyWith<$Res> {
  __$$WorkspaceItemImplCopyWithImpl(
    _$WorkspaceItemImpl _value,
    $Res Function(_$WorkspaceItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkspaceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconName = null,
    Object? colorValue = null,
    Object? isDefault = null,
    Object? enabledFeatures = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$WorkspaceItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        iconName: null == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String,
        colorValue: null == colorValue
            ? _value.colorValue
            : colorValue // ignore: cast_nullable_to_non_nullable
                  as int,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        enabledFeatures: null == enabledFeatures
            ? _value._enabledFeatures
            : enabledFeatures // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$WorkspaceItemImpl implements _WorkspaceItem {
  const _$WorkspaceItemImpl({
    required this.id,
    required this.name,
    this.iconName = 'person_outline_rounded',
    this.colorValue = 0xFF4F46E5,
    this.isDefault = false,
    final List<String> enabledFeatures = const [
      'notes',
      'tasks',
      'reminders',
      'read',
      'watch',
      'learning_paths',
    ],
    required this.createdAt,
    required this.updatedAt,
  }) : _enabledFeatures = enabledFeatures;

  factory _$WorkspaceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String iconName;
  @override
  @JsonKey()
  final int colorValue;
  @override
  @JsonKey()
  final bool isDefault;
  final List<String> _enabledFeatures;
  @override
  @JsonKey()
  List<String> get enabledFeatures {
    if (_enabledFeatures is EqualUnmodifiableListView) return _enabledFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enabledFeatures);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WorkspaceItem(id: $id, name: $name, iconName: $iconName, colorValue: $colorValue, isDefault: $isDefault, enabledFeatures: $enabledFeatures, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            const DeepCollectionEquality().equals(
              other._enabledFeatures,
              _enabledFeatures,
            ) &&
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
    name,
    iconName,
    colorValue,
    isDefault,
    const DeepCollectionEquality().hash(_enabledFeatures),
    createdAt,
    updatedAt,
  );

  /// Create a copy of WorkspaceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceItemImplCopyWith<_$WorkspaceItemImpl> get copyWith =>
      __$$WorkspaceItemImplCopyWithImpl<_$WorkspaceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceItemImplToJson(this);
  }
}

abstract class _WorkspaceItem implements WorkspaceItem {
  const factory _WorkspaceItem({
    required final String id,
    required final String name,
    final String iconName,
    final int colorValue,
    final bool isDefault,
    final List<String> enabledFeatures,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$WorkspaceItemImpl;

  factory _WorkspaceItem.fromJson(Map<String, dynamic> json) =
      _$WorkspaceItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get iconName;
  @override
  int get colorValue;
  @override
  bool get isDefault;
  @override
  List<String> get enabledFeatures;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of WorkspaceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceItemImplCopyWith<_$WorkspaceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
