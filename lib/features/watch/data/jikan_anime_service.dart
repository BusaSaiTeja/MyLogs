import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AnimeSearchResult {
  const AnimeSearchResult({
    required this.title,
    this.totalEpisodes,
    this.year,
    this.posterUrl,
    this.synopsis,
    this.genres = const [],
  });

  final String title;
  final int? totalEpisodes;
  final int? year;
  final String? posterUrl;
  final String? synopsis;
  final List<String> genres;
}

/// Free & Open Anime API (MyAnimeList data via Jikan v4 API).
/// Docs: https://jikan.moe/
class JikanAnimeService {
  JikanAnimeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://api.jikan.moe/v4/anime';

  /// Searches Jikan/MAL for anime series by title.
  Future<List<AnimeSearchResult>> searchAnime(String title) async {
    final cleanQuery = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanQuery.isEmpty) return [];

    final uri = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(cleanQuery)}&limit=6');

    try {
      final response = await _client.get(
        uri,
        headers: {'User-Agent': 'MyLogsApp/1.0 (Flutter)'},
      ).timeout(const Duration(seconds: 8));

      if (kDebugMode) {
        print('[JikanAnime] Search status for "$cleanQuery": ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['data'] as List<dynamic>?;
        if (results == null || results.isEmpty) return [];

        return results.map((item) {
          final anime = item as Map<String, dynamic>;

          // Title preference: English title if present, else default title
          final titleEnglish = anime['title_english'] as String?;
          final titleDefault = anime['title'] as String? ?? title;
          final finalTitle = (titleEnglish != null && titleEnglish.isNotEmpty)
              ? titleEnglish
              : titleDefault;

          // Episodes
          final episodes = anime['episodes'] as int?;

          // Year
          final year = anime['year'] as int? ??
              (anime['aired']?['prop']?['from']?['year'] as int?);

          // Poster Image
          final images = anime['images'] as Map<String, dynamic>?;
          final jpg = images?['jpg'] as Map<String, dynamic>?;
          final posterUrl = (jpg?['large_image_url'] as String?) ??
              (jpg?['image_url'] as String?);

          // Genres
          final rawGenres = (anime['genres'] as List<dynamic>?) ?? [];
          final genres = rawGenres
              .map((g) => (g as Map<String, dynamic>)['name'] as String?)
              .whereType<String>()
              .toList();

          // Synopsis
          final synopsis = anime['synopsis'] as String?;

          return AnimeSearchResult(
            title: finalTitle,
            totalEpisodes: episodes,
            year: year,
            posterUrl: posterUrl,
            synopsis: synopsis,
            genres: genres,
          );
        }).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('[JikanAnime] Error searching anime for "$cleanQuery": $e');
      }
    }
    return [];
  }
}
