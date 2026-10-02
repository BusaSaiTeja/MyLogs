import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';
part 'media_item.g.dart';

enum MediaCategory { movie, animatedMovie, anime }

extension MediaCategoryExt on MediaCategory {
  String get label {
    switch (this) {
      case MediaCategory.movie: return 'Movies';
      case MediaCategory.animatedMovie: return 'Animated Movies';
      case MediaCategory.anime: return 'Anime';
    }
  }
}

enum MediaStatus { planToWatch, watching, completed, onHold, dropped }

extension MediaStatusExt on MediaStatus {
  String get label {
    switch (this) {
      case MediaStatus.planToWatch: return 'Plan to Watch';
      case MediaStatus.watching: return 'Watching';
      case MediaStatus.completed: return 'Completed';
      case MediaStatus.onHold: return 'On Hold';
      case MediaStatus.dropped: return 'Dropped';
    }
  }
}

@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem({
    required String id,
    required String title,
    required MediaCategory category,
    @Default(MediaStatus.planToWatch) MediaStatus status,
    int? year,
    String? synopsis,
    String? posterUrl,
    @Default([]) List<String> genres,
    double? rating,
    @Default(0) int episodesWatched,
    int? totalEpisodes,
    String? language,
    String? notes,
    @Default('') String workspaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json) => _$MediaItemFromJson(json);
}
