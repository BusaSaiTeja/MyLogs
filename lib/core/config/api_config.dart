/// Core API Configuration & Keys
abstract final class ApiConfig {
  /// TMDB API Key (v3)
  /// Injected at runtime via `--dart-define=TMDB_API_KEY=your_key`
  static const String tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

  /// TMDB Base Image URL for posters (w500 size)
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  /// TMDB API Base URL
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
}
