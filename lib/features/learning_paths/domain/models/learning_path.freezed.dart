// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PathStep _$PathStepFromJson(Map<String, dynamic> json) {
  return _PathStep.fromJson(json);
}

/// @nodoc
mixin _$PathStep {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;
  String? get resourceUrl => throw _privateConstructorUsedError;

  /// Serializes this PathStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PathStepCopyWith<PathStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathStepCopyWith<$Res> {
  factory $PathStepCopyWith(PathStep value, $Res Function(PathStep) then) =
      _$PathStepCopyWithImpl<$Res, PathStep>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    bool isCompleted,
    int? order,
    String? resourceUrl,
  });
}

/// @nodoc
class _$PathStepCopyWithImpl<$Res, $Val extends PathStep>
    implements $PathStepCopyWith<$Res> {
  _$PathStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? order = freezed,
    Object? resourceUrl = freezed,
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
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int?,
            resourceUrl: freezed == resourceUrl
                ? _value.resourceUrl
                : resourceUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PathStepImplCopyWith<$Res>
    implements $PathStepCopyWith<$Res> {
  factory _$$PathStepImplCopyWith(
    _$PathStepImpl value,
    $Res Function(_$PathStepImpl) then,
  ) = __$$PathStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    bool isCompleted,
    int? order,
    String? resourceUrl,
  });
}

/// @nodoc
class __$$PathStepImplCopyWithImpl<$Res>
    extends _$PathStepCopyWithImpl<$Res, _$PathStepImpl>
    implements _$$PathStepImplCopyWith<$Res> {
  __$$PathStepImplCopyWithImpl(
    _$PathStepImpl _value,
    $Res Function(_$PathStepImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? order = freezed,
    Object? resourceUrl = freezed,
  }) {
    return _then(
      _$PathStepImpl(
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
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int?,
        resourceUrl: freezed == resourceUrl
            ? _value.resourceUrl
            : resourceUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PathStepImpl implements _PathStep {
  const _$PathStepImpl({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.order,
    this.resourceUrl,
  });

  factory _$PathStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$PathStepImplFromJson(json);

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
  final int? order;
  @override
  final String? resourceUrl;

  @override
  String toString() {
    return 'PathStep(id: $id, title: $title, description: $description, isCompleted: $isCompleted, order: $order, resourceUrl: $resourceUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PathStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.resourceUrl, resourceUrl) ||
                other.resourceUrl == resourceUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    isCompleted,
    order,
    resourceUrl,
  );

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PathStepImplCopyWith<_$PathStepImpl> get copyWith =>
      __$$PathStepImplCopyWithImpl<_$PathStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PathStepImplToJson(this);
  }
}

abstract class _PathStep implements PathStep {
  const factory _PathStep({
    required final String id,
    required final String title,
    final String? description,
    final bool isCompleted,
    final int? order,
    final String? resourceUrl,
  }) = _$PathStepImpl;

  factory _PathStep.fromJson(Map<String, dynamic> json) =
      _$PathStepImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  bool get isCompleted;
  @override
  int? get order;
  @override
  String? get resourceUrl;

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PathStepImplCopyWith<_$PathStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningPath _$LearningPathFromJson(Map<String, dynamic> json) {
  return _LearningPath.fromJson(json);
}

/// @nodoc
mixin _$LearningPath {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<PathStep> get steps => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LearningPath to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPathCopyWith<LearningPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathCopyWith<$Res> {
  factory $LearningPathCopyWith(
    LearningPath value,
    $Res Function(LearningPath) then,
  ) = _$LearningPathCopyWithImpl<$Res, LearningPath>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    List<PathStep> steps,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$LearningPathCopyWithImpl<$Res, $Val extends LearningPath>
    implements $LearningPathCopyWith<$Res> {
  _$LearningPathCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? steps = null,
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
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<PathStep>,
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
abstract class _$$LearningPathImplCopyWith<$Res>
    implements $LearningPathCopyWith<$Res> {
  factory _$$LearningPathImplCopyWith(
    _$LearningPathImpl value,
    $Res Function(_$LearningPathImpl) then,
  ) = __$$LearningPathImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    List<PathStep> steps,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$LearningPathImplCopyWithImpl<$Res>
    extends _$LearningPathCopyWithImpl<$Res, _$LearningPathImpl>
    implements _$$LearningPathImplCopyWith<$Res> {
  __$$LearningPathImplCopyWithImpl(
    _$LearningPathImpl _value,
    $Res Function(_$LearningPathImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? steps = null,
    Object? workspaceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$LearningPathImpl(
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
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<PathStep>,
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
class _$LearningPathImpl implements _LearningPath {
  const _$LearningPathImpl({
    required this.id,
    required this.title,
    this.description,
    final List<PathStep> steps = const [],
    this.workspaceId = '',
    required this.createdAt,
    required this.updatedAt,
  }) : _steps = steps;

  factory _$LearningPathImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPathImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  final List<PathStep> _steps;
  @override
  @JsonKey()
  List<PathStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
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
    return 'LearningPath(id: $id, title: $title, description: $description, steps: $steps, workspaceId: $workspaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPathImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
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
    const DeepCollectionEquality().hash(_steps),
    workspaceId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPathImplCopyWith<_$LearningPathImpl> get copyWith =>
      __$$LearningPathImplCopyWithImpl<_$LearningPathImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPathImplToJson(this);
  }
}

abstract class _LearningPath implements LearningPath {
  const factory _LearningPath({
    required final String id,
    required final String title,
    final String? description,
    final List<PathStep> steps,
    final String workspaceId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$LearningPathImpl;

  factory _LearningPath.fromJson(Map<String, dynamic> json) =
      _$LearningPathImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<PathStep> get steps;
  @override
  String get workspaceId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPathImplCopyWith<_$LearningPathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
