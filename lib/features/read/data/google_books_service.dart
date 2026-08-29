import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GoogleBookSuggestion {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final int? pageCount;
  final List<String> categories;
  final String? language;
  final String? description;

  const GoogleBookSuggestion({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.pageCount,
    this.categories = const [],
    this.language,
    this.description,
  });
}

/// Robust Book Search Service using Open Library with in-memory caching and resilient error handling.
class GoogleBooksService {
  static const _baseUrl = 'https://openlibrary.org/search.json';
  static const _coverBase = 'https://covers.openlibrary.org/b/id';

  static const _isoLanguageMap = {
    'eng': 'English',
    'spa': 'Spanish',
    'fre': 'French',
    'ger': 'German',
    'ita': 'Italian',
    'jpn': 'Japanese',
    'chi': 'Chinese',
    'rus': 'Russian',
    'por': 'Portuguese',
    'hin': 'Hindi',
    'kor': 'Korean',
    'ara': 'Arabic',
    'dut': 'Dutch',
    'pol': 'Polish',
    'tur': 'Turkish',
  };

  // In-memory LRU cache to prevent redundant network calls
  final Map<String, List<GoogleBookSuggestion>> _cache = {};

  Future<List<GoogleBookSuggestion>> searchBooks(String title, {String? author}) async {
    final cleanTitle = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanTitle.length < 2) return [];

    final cacheKey = '$cleanTitle|${author ?? ''}'.toLowerCase();
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final queryParts = [cleanTitle];
    if (author != null && author.trim().isNotEmpty) {
      queryParts.add(author.trim().replaceAll(RegExp(r'\s+'), ' '));
    }

    final encoded = Uri.encodeComponent(queryParts.join(' '));
    final uri = Uri.parse(
      '$_baseUrl?q=$encoded&limit=10&fields=key,title,author_name,number_of_pages_median,subject,language,cover_i',
    );

    try {
      final response = await http
          .get(uri, headers: {'User-Agent': 'MyLogsApp/1.0 (Mobile App)'})
          .timeout(const Duration(seconds: 7));

      if (response.statusCode != 200) {
        if (kDebugMode) print('[OpenLibrary] Status: ${response.statusCode}');
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final docs = data['docs'] as List<dynamic>?;
      if (docs == null || docs.isEmpty) return [];

      final list = docs.map((doc) {
        final d = doc as Map<String, dynamic>;

        final bookTitle = d['title'] as String? ?? 'Untitled';
        final authors = (d['author_name'] as List?)?.cast<String>() ?? [];
        final authorStr = authors.isNotEmpty ? authors.take(2).join(', ') : 'Unknown Author';

        final coverId = d['cover_i'];
        final coverUrl = coverId != null ? '$_coverBase/$coverId-M.jpg' : null;
        final pages = d['number_of_pages_median'] as int?;
        final subjects = (d['subject'] as List?)?.cast<String>().take(3).toList() ?? [];

        final langs = (d['language'] as List?)?.cast<String>() ?? [];
        final rawLang = langs.isNotEmpty ? langs.first : null;
        final langFull = rawLang != null
            ? (_isoLanguageMap[rawLang.toLowerCase()] ?? rawLang.toUpperCase())
            : null;

        final key = d['key'] as String? ?? UniqueKey().toString();

        return GoogleBookSuggestion(
          id: key,
          title: bookTitle,
          author: authorStr,
          coverUrl: coverUrl,
          pageCount: pages,
          categories: subjects,
          language: langFull,
        );
      }).toList();

      if (list.isNotEmpty) {
        if (_cache.length > 50) _cache.clear();
        _cache[cacheKey] = list;
      }
      return list;
    } catch (e) {
      if (kDebugMode) print('[OpenLibrary Error]: $e');
      return [];
    }
  }
}
