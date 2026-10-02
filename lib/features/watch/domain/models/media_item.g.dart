// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaItemImpl _$$MediaItemImplFromJson(Map<String, dynamic> json) =>
    _$MediaItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: $enumDecode(_$MediaCategoryEnumMap, json['category']),
      status:
          $enumDecodeNullable(_$MediaStatusEnumMap, json['status']) ??
          MediaStatus.planToWatch,
      year: (json['year'] as num?)?.toInt(),
      synopsis: json['synopsis'] as String?,
      posterUrl: json['posterUrl'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble(),
      episodesWatched: (json['episodesWatched'] as num?)?.toInt() ?? 0,
      totalEpisodes: (json['totalEpisodes'] as num?)?.toInt(),
      language: json['language'] as String?,
      notes: json['notes'] as String?,
      workspaceId: json['workspaceId'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MediaItemImplToJson(_$MediaItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$MediaCategoryEnumMap[instance.category]!,
      'status': _$MediaStatusEnumMap[instance.status]!,
      'year': instance.year,
      'synopsis': instance.synopsis,
      'posterUrl': instance.posterUrl,
      'genres': instance.genres,
      'rating': instance.rating,
      'episodesWatched': instance.episodesWatched,
      'totalEpisodes': instance.totalEpisodes,
      'language': instance.language,
      'notes': instance.notes,
      'workspaceId': instance.workspaceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MediaCategoryEnumMap = {
  MediaCategory.movie: 'movie',
  MediaCategory.animatedMovie: 'animatedMovie',
  MediaCategory.anime: 'anime',
};

const _$MediaStatusEnumMap = {
  MediaStatus.planToWatch: 'planToWatch',
  MediaStatus.watching: 'watching',
  MediaStatus.completed: 'completed',
  MediaStatus.onHold: 'onHold',
  MediaStatus.dropped: 'dropped',
};
