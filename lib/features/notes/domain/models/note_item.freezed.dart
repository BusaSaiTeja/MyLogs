// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NoteItem _$NoteItemFromJson(Map<String, dynamic> json) {
  return _NoteItem.fromJson(json);
}

/// @nodoc
mixin _$NoteItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NoteItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteItemCopyWith<NoteItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteItemCopyWith<$Res> {
  factory $NoteItemCopyWith(NoteItem value, $Res Function(NoteItem) then) =
      _$NoteItemCopyWithImpl<$Res, NoteItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    List<String> tags,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$NoteItemCopyWithImpl<$Res, $Val extends NoteItem>
    implements $NoteItemCopyWith<$Res> {
  _$NoteItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$NoteItemImplCopyWith<$Res>
    implements $NoteItemCopyWith<$Res> {
  factory _$$NoteItemImplCopyWith(
    _$NoteItemImpl value,
    $Res Function(_$NoteItemImpl) then,
  ) = __$$NoteItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    List<String> tags,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$NoteItemImplCopyWithImpl<$Res>
    extends _$NoteItemCopyWithImpl<$Res, _$NoteItemImpl>
    implements _$$NoteItemImplCopyWith<$Res> {
  __$$NoteItemImplCopyWithImpl(
    _$NoteItemImpl _value,
    $Res Function(_$NoteItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? workspaceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$NoteItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$NoteItemImpl implements _NoteItem {
  const _$NoteItemImpl({
    required this.id,
    required this.title,
    required this.content,
    final List<String> tags = const [],
    this.workspaceId = '',
    required this.createdAt,
    required this.updatedAt,
  }) : _tags = tags;

  factory _$NoteItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final String workspaceId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NoteItem(id: $id, title: $title, content: $content, tags: $tags, workspaceId: $workspaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
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
    content,
    const DeepCollectionEquality().hash(_tags),
    workspaceId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of NoteItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteItemImplCopyWith<_$NoteItemImpl> get copyWith =>
      __$$NoteItemImplCopyWithImpl<_$NoteItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteItemImplToJson(this);
  }
}

abstract class _NoteItem implements NoteItem {
  const factory _NoteItem({
    required final String id,
    required final String title,
    required final String content,
    final List<String> tags,
    final String workspaceId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$NoteItemImpl;

  factory _NoteItem.fromJson(Map<String, dynamic> json) =
      _$NoteItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get tags;
  @override
  String get workspaceId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of NoteItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteItemImplCopyWith<_$NoteItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
