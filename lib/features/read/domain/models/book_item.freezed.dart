// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookItem _$BookItemFromJson(Map<String, dynamic> json) {
  return _BookItem.fromJson(json);
}

/// @nodoc
mixin _$BookItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  BookStatus get status => throw _privateConstructorUsedError;
  bool get isCollection => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get synopsis => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookItemCopyWith<BookItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookItemCopyWith<$Res> {
  factory $BookItemCopyWith(BookItem value, $Res Function(BookItem) then) =
      _$BookItemCopyWithImpl<$Res, BookItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String author,
    BookStatus status,
    bool isCollection,
    String? coverUrl,
    String? synopsis,
    List<String> genres,
    double? rating,
    int currentPage,
    int? totalPages,
    String? notes,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$BookItemCopyWithImpl<$Res, $Val extends BookItem>
    implements $BookItemCopyWith<$Res> {
  _$BookItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? status = null,
    Object? isCollection = null,
    Object? coverUrl = freezed,
    Object? synopsis = freezed,
    Object? genres = null,
    Object? rating = freezed,
    Object? currentPage = null,
    Object? totalPages = freezed,
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
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BookStatus,
            isCollection: null == isCollection
                ? _value.isCollection
                : isCollection // ignore: cast_nullable_to_non_nullable
                      as bool,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            synopsis: freezed == synopsis
                ? _value.synopsis
                : synopsis // ignore: cast_nullable_to_non_nullable
                      as String?,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: freezed == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$BookItemImplCopyWith<$Res>
    implements $BookItemCopyWith<$Res> {
  factory _$$BookItemImplCopyWith(
    _$BookItemImpl value,
    $Res Function(_$BookItemImpl) then,
  ) = __$$BookItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String author,
    BookStatus status,
    bool isCollection,
    String? coverUrl,
    String? synopsis,
    List<String> genres,
    double? rating,
    int currentPage,
    int? totalPages,
    String? notes,
    String workspaceId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$BookItemImplCopyWithImpl<$Res>
    extends _$BookItemCopyWithImpl<$Res, _$BookItemImpl>
    implements _$$BookItemImplCopyWith<$Res> {
  __$$BookItemImplCopyWithImpl(
    _$BookItemImpl _value,
    $Res Function(_$BookItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? status = null,
    Object? isCollection = null,
    Object? coverUrl = freezed,
    Object? synopsis = freezed,
    Object? genres = null,
    Object? rating = freezed,
    Object? currentPage = null,
    Object? totalPages = freezed,
    Object? notes = freezed,
    Object? workspaceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BookItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BookStatus,
        isCollection: null == isCollection
            ? _value.isCollection
            : isCollection // ignore: cast_nullable_to_non_nullable
                  as bool,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        synopsis: freezed == synopsis
            ? _value.synopsis
            : synopsis // ignore: cast_nullable_to_non_nullable
                  as String?,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: freezed == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$BookItemImpl implements _BookItem {
  const _$BookItemImpl({
    required this.id,
    required this.title,
    required this.author,
    this.status = BookStatus.toRead,
    this.isCollection = false,
    this.coverUrl,
    this.synopsis,
    final List<String> genres = const [],
    this.rating,
    this.currentPage = 0,
    this.totalPages,
    this.notes,
    this.workspaceId = '',
    required this.createdAt,
    required this.updatedAt,
  }) : _genres = genres;

  factory _$BookItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String author;
  @override
  @JsonKey()
  final BookStatus status;
  @override
  @JsonKey()
  final bool isCollection;
  @override
  final String? coverUrl;
  @override
  final String? synopsis;
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
  final int currentPage;
  @override
  final int? totalPages;
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
    return 'BookItem(id: $id, title: $title, author: $author, status: $status, isCollection: $isCollection, coverUrl: $coverUrl, synopsis: $synopsis, genres: $genres, rating: $rating, currentPage: $currentPage, totalPages: $totalPages, notes: $notes, workspaceId: $workspaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isCollection, isCollection) ||
                other.isCollection == isCollection) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.synopsis, synopsis) ||
                other.synopsis == synopsis) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
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
    author,
    status,
    isCollection,
    coverUrl,
    synopsis,
    const DeepCollectionEquality().hash(_genres),
    rating,
    currentPage,
    totalPages,
    notes,
    workspaceId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of BookItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookItemImplCopyWith<_$BookItemImpl> get copyWith =>
      __$$BookItemImplCopyWithImpl<_$BookItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookItemImplToJson(this);
  }
}

abstract class _BookItem implements BookItem {
  const factory _BookItem({
    required final String id,
    required final String title,
    required final String author,
    final BookStatus status,
    final bool isCollection,
    final String? coverUrl,
    final String? synopsis,
    final List<String> genres,
    final double? rating,
    final int currentPage,
    final int? totalPages,
    final String? notes,
    final String workspaceId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$BookItemImpl;

  factory _BookItem.fromJson(Map<String, dynamic> json) =
      _$BookItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get author;
  @override
  BookStatus get status;
  @override
  bool get isCollection;
  @override
  String? get coverUrl;
  @override
  String? get synopsis;
  @override
  List<String> get genres;
  @override
  double? get rating;
  @override
  int get currentPage;
  @override
  int? get totalPages;
  @override
  String? get notes;
  @override
  String get workspaceId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of BookItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookItemImplCopyWith<_$BookItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
