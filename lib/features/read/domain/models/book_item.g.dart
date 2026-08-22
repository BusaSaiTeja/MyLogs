// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookItemImpl _$$BookItemImplFromJson(Map<String, dynamic> json) =>
    _$BookItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      status:
          $enumDecodeNullable(_$BookStatusEnumMap, json['status']) ??
          BookStatus.toRead,
      coverUrl: json['coverUrl'] as String?,
      synopsis: json['synopsis'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble(),
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookItemImplToJson(_$BookItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'status': _$BookStatusEnumMap[instance.status]!,
      'coverUrl': instance.coverUrl,
      'synopsis': instance.synopsis,
      'genres': instance.genres,
      'rating': instance.rating,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BookStatusEnumMap = {
  BookStatus.toRead: 'toRead',
  BookStatus.reading: 'reading',
  BookStatus.read: 'read',
  BookStatus.onHold: 'onHold',
  BookStatus.dropped: 'dropped',
  BookStatus.collection: 'collection',
};
