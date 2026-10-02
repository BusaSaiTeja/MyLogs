import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_logs/core/config/api_config.dart';

class TmdbSearchResult {
  const TmdbSearchResult({
    required this.title,
    this.year,
    this.posterUrl,
    this.synopsis,
    this.language,
    this.genres = const [],
    this.totalEpisodes,
  });

  final String title;
  final int? year;
  final String? posterUrl;
  final String? synopsis;
  final String? language;
  final List<String> genres;
  final int? totalEpisodes;
}

class TmdbService {
  TmdbService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _omdbApiKey = String.fromEnvironment('OMDB_API_KEY');

  static const Map<int, String> _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
    10759: 'Action & Adventure',
    10762: 'Kids',
    10765: 'Sci-Fi & Fantasy',
  };

  /// Searches movies with automatic OMDB + TMDB fallback for 100% global reliability.
  Future<List<TmdbSearchResult>> searchMovies(String title) async {
    final cleanQuery = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanQuery.isEmpty) return [];

    // Try OMDB first (Universal CDN, no ISP blocks in Asia/India)
    try {
      final omdbResults = await _searchOmdb(cleanQuery);
      if (omdbResults.isNotEmpty) {
        return omdbResults;
      }
    } catch (e) {
      if (kDebugMode) print('[OMDB] Error: $e');
    }

    // Fallback to TMDB
    try {
      final tmdbResults = await _searchTmdbMovies(cleanQuery);
      if (tmdbResults.isNotEmpty) {
        return tmdbResults;
      }
    } catch (e) {
      if (kDebugMode) print('[TMDB] Error: $e');
    }

    return [];
  }

  /// Searches OMDB for movies & series.
  Future<List<TmdbSearchResult>> _searchOmdb(String cleanQuery) async {
    if (_omdbApiKey.isEmpty) return [];

    final uri = Uri.https('www.omdbapi.com', '', {
      'apikey': _omdbApiKey,
      's': cleanQuery,
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 6));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['Response'] == 'True') {
        final searchList = (data['Search'] as List<dynamic>?) ?? [];
        final qLower = cleanQuery.toLowerCase();

        // Sort startsWith first
        searchList.sort((a, b) {
          final tA = (a['Title'] as String? ?? '').toLowerCase();
          final tB = (b['Title'] as String? ?? '').toLowerCase();
          final sA = tA.startsWith(qLower);
          final sB = tB.startsWith(qLower);
          if (sA && !sB) return -1;
          if (!sA && sB) return 1;
          return 0;
        });

        // Enrich the top results with detail lookups in parallel
        final results = await Future.wait(
          searchList.take(6).map((item) async {
            final map = item as Map<String, dynamic>;
            final imdbId = map['imdbID'] as String?;
            final poster = map['Poster'] as String?;
            final posterUrl = (poster != null && poster != 'N/A') ? poster : null;
            final yearStr = map['Year'] as String?;
            int? year;
            if (yearStr != null && yearStr.length >= 4) {
              year = int.tryParse(yearStr.substring(0, 4));
            }

            String? synopsis;
            List<String> genres = [];
            if (map['Type'] == 'movie' && map.containsKey('Genre')) {
              genres = (map['Genre'] as String)
                  .split(',')
                  .map((g) => g.trim())
                  .where((g) => g.isNotEmpty && g != 'N/A')
                  .toList();
            }

            // Quick detail fetch for top 3 to get full synopsis & genre
            if (imdbId != null && searchList.indexOf(item) < 3) {
              try {
                final detailUri = Uri.https('www.omdbapi.com', '', {
                  'apikey': _omdbApiKey,
                  'i': imdbId,
                  'plot': 'short',
                });
                final detailRes =
                    await _client.get(detailUri).timeout(const Duration(seconds: 3));
                if (detailRes.statusCode == 200) {
                  final dData = jsonDecode(detailRes.body) as Map<String, dynamic>;
                  if (dData['Plot'] != null && dData['Plot'] != 'N/A') {
                    synopsis = dData['Plot'] as String;
                  }
                  if (dData['Genre'] != null && dData['Genre'] != 'N/A') {
                    genres = (dData['Genre'] as String)
                        .split(',')
                        .map((g) => g.trim())
                        .where((g) => g.isNotEmpty)
                        .toList();
                  }
                }
              } catch (_) {}
            }

            return TmdbSearchResult(
              title: (map['Title'] as String?) ?? cleanQuery,
              year: year,
              posterUrl: posterUrl,
              synopsis: synopsis,
              genres: genres,
              language: 'ENGLISH',
            );
          }),
        );

        return results;
      }
    }
    return [];
  }

  /// TMDB Movie Search
  Future<List<TmdbSearchResult>> _searchTmdbMovies(String cleanQuery) async {
    if (ApiConfig.tmdbApiKey.isEmpty) return [];

    final uri = Uri.https('api.themoviedb.org', '/3/search/movie', {
      'api_key': ApiConfig.tmdbApiKey,
      'query': cleanQuery,
      'include_adult': 'false',
    });

    final response = await _client.get(
      uri,
      headers: {
        'User-Agent': 'MyLogsApp/1.0 (Flutter)',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 6));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>?) ?? [];
      if (results.isEmpty) return [];

      _sortResultsByRelevance(results, cleanQuery, titleKey: 'title');

      return results.take(6).map((item) {
        final first = item as Map<String, dynamic>;
        final releaseDate = first['release_date'] as String?;
        int? year;
        if (releaseDate != null && releaseDate.length >= 4) {
          year = int.tryParse(releaseDate.substring(0, 4));
        }

        final posterPath = first['poster_path'] as String?;
        final posterUrl =
            posterPath != null ? '${ApiConfig.tmdbImageBaseUrl}$posterPath' : null;

        final genreIds =
            (first['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [];
        final genres =
            genreIds.map((id) => _genreMap[id]).whereType<String>().toList();

        final langCode = first['original_language'] as String?;

        return TmdbSearchResult(
          title: (first['title'] as String?) ?? cleanQuery,
          year: year,
          posterUrl: posterUrl,
          synopsis: first['overview'] as String?,
          language: langCode?.toUpperCase(),
          genres: genres,
        );
      }).toList();
    }
    return [];
  }

  /// Searches TMDB for TV Shows and Anime series by title.
  Future<List<TmdbSearchResult>> searchTv(String title) async {
    final cleanQuery = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanQuery.isEmpty) return [];

    try {
      final omdbResults = await _searchOmdb(cleanQuery);
      if (omdbResults.isNotEmpty) {
        return omdbResults;
      }
    } catch (_) {}

    return [];
  }

  /// Sorts items so titles starting with the query appear first.
  void _sortResultsByRelevance(List<dynamic> items, String query, {required String titleKey}) {
    final qLower = query.toLowerCase();
    items.sort((a, b) {
      final mapA = a as Map<String, dynamic>;
      final mapB = b as Map<String, dynamic>;

      final nameA = (mapA[titleKey] as String? ?? '').toLowerCase();
      final nameB = (mapB[titleKey] as String? ?? '').toLowerCase();

      final startsA = nameA.startsWith(qLower);
      final startsB = nameB.startsWith(qLower);

      if (startsA && !startsB) return -1;
      if (!startsA && startsB) return 1;
      return 0;
    });
  }
}
