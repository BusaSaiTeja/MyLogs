// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MediaItem _$MediaItemFromJson(Map<String, dynamic> json) {
  return _MediaItem.fromJson(json);
}

/// @nodoc
mixin _$MediaItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  MediaCategory get category => throw _privateConstructorUsedError;
  MediaStatus get status => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get synopsis => throw _privateConstructorUsedError;
  String? get posterUrl => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int get episodesWatched => throw _privateConstructorUsedError;
  int? get totalEpisodes => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MediaItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaItemCopyWith<MediaItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaItemCopyWith<$Res> {
  factory $MediaItemCopyWith(MediaItem value, $Res Function(MediaItem) then) =
      _$MediaItemCopyWithImpl<$Res, MediaItem>;
  @useResult
  $Res call({
    String id,
    String title,
    MediaCategory category,
    MediaStatus status,
    int? year,
    String? synopsis,
    String? posterUrl,
    List<String> genres,
    double? rating,
    int episodesWatched,
    int? totalEpisodes,
    String? language,
    String? notes,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$MediaItemCopyWithImpl<$Res, $Val extends MediaItem>
    implements $MediaItemCopyWith<$Res> {
  _$MediaItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? status = null,
    Object? year = freezed,
    Object? synopsis = freezed,
    Object? posterUrl = freezed,
    Object? genres = null,
    Object? rating = freezed,
    Object? episodesWatched = null,
    Object? totalEpisodes = freezed,
    Object? language = freezed,
    Object? notes = freezed,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as MediaCategory,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MediaStatus,
            year: freezed == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int?,
            synopsis: freezed == synopsis
                ? _value.synopsis
                : synopsis // ignore: cast_nullable_to_non_nullable
                      as String?,
            posterUrl: freezed == posterUrl
                ? _value.posterUrl
                : posterUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            episodesWatched: null == episodesWatched
                ? _value.episodesWatched
                : episodesWatched // ignore: cast_nullable_to_non_nullable
                      as int,
            totalEpisodes: freezed == totalEpisodes
                ? _value.totalEpisodes
                : totalEpisodes // ignore: cast_nullable_to_non_nullable
                      as int?,
            language: freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$MediaItemImplCopyWith<$Res>
    implements $MediaItemCopyWith<$Res> {
  factory _$$MediaItemImplCopyWith(
    _$MediaItemImpl value,
    $Res Function(_$MediaItemImpl) then,
  ) = __$$MediaItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    MediaCategory category,
    MediaStatus status,
    int? year,
    String? synopsis,
    String? posterUrl,
    List<String> genres,
    double? rating,
    int episodesWatched,
    int? totalEpisodes,
    String? language,
    String? notes,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$MediaItemImplCopyWithImpl<$Res>
    extends _$MediaItemCopyWithImpl<$Res, _$MediaItemImpl>
    implements _$$MediaItemImplCopyWith<$Res> {
  __$$MediaItemImplCopyWithImpl(
    _$MediaItemImpl _value,
    $Res Function(_$MediaItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? status = null,
    Object? year = freezed,
    Object? synopsis = freezed,
    Object? posterUrl = freezed,
    Object? genres = null,
    Object? rating = freezed,
    Object? episodesWatched = null,
    Object? totalEpisodes = freezed,
    Object? language = freezed,
    Object? notes = freezed,
    Object? workspaceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MediaItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as MediaCategory,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MediaStatus,
        year: freezed == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int?,
        synopsis: freezed == synopsis
            ? _value.synopsis
            : synopsis // ignore: cast_nullable_to_non_nullable
                  as String?,
        posterUrl: freezed == posterUrl
            ? _value.posterUrl
            : posterUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        episodesWatched: null == episodesWatched
            ? _value.episodesWatched
            : episodesWatched // ignore: cast_nullable_to_non_nullable
                  as int,
        totalEpisodes: freezed == totalEpisodes
            ? _value.totalEpisodes
            : totalEpisodes // ignore: cast_nullable_to_non_nullable
                  as int?,
        language: freezed == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$MediaItemImpl implements _MediaItem {
  const _$MediaItemImpl({
    required this.id,
    required this.title,
    required this.category,
    this.status = MediaStatus.planToWatch,
    this.year,
    this.synopsis,
    this.posterUrl,
    final List<String> genres = const [],
    this.rating,
    this.episodesWatched = 0,
    this.totalEpisodes,
    this.language,
    this.notes,
    this.workspaceId = '',
    required this.createdAt,
    required this.updatedAt,
  }) : _genres = genres;

  factory _$MediaItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final MediaCategory category;
  @override
  @JsonKey()
  final MediaStatus status;
  @override
  final int? year;
  @override
  final String? synopsis;
  @override
  final String? posterUrl;
  final List<String> _genres;
  @override
  @JsonKey()
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final double? rating;
  @override
  @JsonKey()
  final int episodesWatched;
  @override
  final int? totalEpisodes;
  @override
  final String? language;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String workspaceId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MediaItem(id: $id, title: $title, category: $category, status: $status, year: $year, synopsis: $synopsis, posterUrl: $posterUrl, genres: $genres, rating: $rating, episodesWatched: $episodesWatched, totalEpisodes: $totalEpisodes, language: $language, notes: $notes, workspaceId: $workspaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.synopsis, synopsis) ||
                other.synopsis == synopsis) &&
            (identical(other.posterUrl, posterUrl) ||
                other.posterUrl == posterUrl) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.episodesWatched, episodesWatched) ||
                other.episodesWatched == episodesWatched) &&
            (identical(other.totalEpisodes, totalEpisodes) ||
                other.totalEpisodes == totalEpisodes) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    category,
    status,
    year,
    synopsis,
    posterUrl,
    const DeepCollectionEquality().hash(_genres),
    rating,
    episodesWatched,
    totalEpisodes,
    language,
    notes,
    workspaceId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MediaItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaItemImplCopyWith<_$MediaItemImpl> get copyWith =>
      __$$MediaItemImplCopyWithImpl<_$MediaItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaItemImplToJson(this);
  }
}

abstract class _MediaItem implements MediaItem {
  const factory _MediaItem({
    required final String id,
    required final String title,
    required final MediaCategory category,
    final MediaStatus status,
    final int? year,
    final String? synopsis,
    final String? posterUrl,
    final List<String> genres,
    final double? rating,
    final int episodesWatched,
    final int? totalEpisodes,
    final String? language,
    final String? notes,
    final String workspaceId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MediaItemImpl;

  factory _MediaItem.fromJson(Map<String, dynamic> json) =
      _$MediaItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  MediaCategory get category;
  @override
  MediaStatus get status;
  @override
  int? get year;
  @override
  String? get synopsis;
  @override
  String? get posterUrl;
  @override
  List<String> get genres;
  @override
  double? get rating;
  @override
  int get episodesWatched;
  @override
  int? get totalEpisodes;
  @override
  String? get language;
  @override
  String? get notes;
  @override
  String get workspaceId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MediaItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaItemImplCopyWith<_$MediaItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
