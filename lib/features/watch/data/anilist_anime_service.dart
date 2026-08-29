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

/// Free & Open Anime API powered by AniList GraphQL API (99.9% uptime).
/// Docs: https://anilist.gitbook.io/anilist-apiv2-docs/
class AniListAnimeService {
  AniListAnimeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _endpoint = 'https://graphql.anilist.co';

  /// Searches AniList for anime series by title.
  Future<List<AnimeSearchResult>> searchAnime(String title) async {
    final cleanQuery = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanQuery.isEmpty) return [];

    const queryBody = '''
      query (\$search: String) {
        Page(perPage: 6) {
          media(search: \$search, type: ANIME) {
            id
            title {
              english
              romaji
            }
            episodes
            seasonYear
            coverImage {
              large
            }
            description
            genres
          }
        }
      }
    ''';

    try {
      final response = await _client.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'MyLogsApp/1.0 (Flutter)',
        },
        body: jsonEncode({
          'query': queryBody,
          'variables': {'search': cleanQuery},
        }),
      ).timeout(const Duration(seconds: 8));

      if (kDebugMode) {
        print('[AniList] Search status for "$cleanQuery": ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final mediaList = data['data']?['Page']?['media'] as List<dynamic>?;
        if (mediaList == null || mediaList.isEmpty) return [];

        return mediaList.map((item) {
          final anime = item as Map<String, dynamic>;

          // Title: English title if present, else Romaji
          final titleMap = anime['title'] as Map<String, dynamic>?;
          final titleEng = titleMap?['english'] as String?;
          final titleRom = titleMap?['romaji'] as String?;
          final finalTitle = (titleEng != null && titleEng.isNotEmpty)
              ? titleEng
              : (titleRom ?? title);

          // Episodes
          final episodes = anime['episodes'] as int?;

          // Year
          final year = anime['seasonYear'] as int?;

          // Poster Image
          final coverMap = anime['coverImage'] as Map<String, dynamic>?;
          final posterUrl = coverMap?['large'] as String?;

          // Genres
          final genres = (anime['genres'] as List<dynamic>?)?.cast<String>() ?? [];

          // Synopsis — strip HTML tags if any (e.g. <br>, <i>)
          String? synopsis = anime['description'] as String?;
          if (synopsis != null) {
            synopsis = synopsis
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .replaceAll('&quot;', '"')
                .replaceAll('&amp;', '&');
          }

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
        print('[AniList] Error searching anime for "$cleanQuery": $e');
      }
    }
    return [];
  }
}
