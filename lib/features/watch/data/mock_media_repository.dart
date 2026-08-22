import 'package:uuid/uuid.dart';
import 'package:my_logs/features/watch/domain/media_repository.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

/// In-memory mock implementation of [MediaRepository].
/// Seeded with 15 realistic entries covering all 3 categories and all statuses.
/// Phase 2: replace with FirestoreMediaRepository at the provider boundary only.
class MockMediaRepository implements MediaRepository {
  MockMediaRepository() {
    _items = List.from(_seed);
  }

  static const _uuid = Uuid();
  late List<MediaItem> _items;

  // ── Seed Data ─────────────────────────────────────────────────────────────
  static final List<MediaItem> _seed = [
    // ── Movies ────────────────────────────────────────────────────────────
    MediaItem(
      id: 'mov-1',
      title: 'Interstellar Journey',
      category: MediaCategory.movie,
      status: MediaStatus.completed,
      rating: 4.8,
      posterUrl: 'https://images.unsplash.com/photo-1608178398319-48f814d0750c?w=400',
      year: 2024,
      genres: ['Sci-Fi', 'Drama'],
      language: 'English',
      synopsis: 'A lone astronaut ventures beyond the edge of the galaxy in search of a new beginning for humanity.',
      notes: 'Stunning visuals. The score was breathtaking.',
      createdAt: DateTime(2024, 8, 1),
      updatedAt: DateTime(2024, 8, 15),
    ),
    MediaItem(
      id: 'mov-2',
      title: 'Neon Shadows',
      category: MediaCategory.movie,
      status: MediaStatus.watching,
      rating: 4.5,
      posterUrl: 'https://images.unsplash.com/photo-1514565131-fce0801e6785?w=400',
      year: 2023,
      genres: ['Thriller', 'Mystery'],
      language: 'English',
      synopsis: 'A neo-noir detective thriller set in a rain-drenched cyberpunk city.',
      createdAt: DateTime(2024, 7, 10),
      updatedAt: DateTime(2024, 8, 20),
    ),
    MediaItem(
      id: 'mov-3',
      title: 'The Quiet Room',
      category: MediaCategory.movie,
      status: MediaStatus.planToWatch,
      posterUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
      year: 2024,
      genres: ['Drama', 'Indie'],
      language: 'English',
      synopsis: 'A slice-of-life indie film about an artist finding peace in solitude.',
      createdAt: DateTime(2024, 8, 5),
      updatedAt: DateTime(2024, 8, 5),
    ),
    MediaItem(
      id: 'mov-4',
      title: 'Blade Runner Legacy',
      category: MediaCategory.movie,
      status: MediaStatus.completed,
      rating: 5.0,
      posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400',
      year: 2023,
      genres: ['Sci-Fi', 'Action'],
      language: 'English',
      synopsis: 'A sequel to the classic that expands the replicant mythology.',
      notes: 'Perfect. Denis Villeneuve at his best.',
      createdAt: DateTime(2024, 1, 12),
      updatedAt: DateTime(2024, 1, 30),
    ),
    MediaItem(
      id: 'mov-5',
      title: 'Optica',
      category: MediaCategory.movie,
      status: MediaStatus.onHold,
      rating: 3.5,
      posterUrl: 'https://images.unsplash.com/photo-1435224654926-ecc9f7fa028c?w=400',
      year: 2022,
      genres: ['Mystery', 'Sci-Fi'],
      language: 'French',
      synopsis: 'A French psychological thriller where a physicist discovers light can carry memory.',
      createdAt: DateTime(2024, 3, 5),
      updatedAt: DateTime(2024, 5, 10),
    ),

    // ── Animated Movies ───────────────────────────────────────────────────
    MediaItem(
      id: 'anm-1',
      title: 'Spirited Away: Remastered',
      category: MediaCategory.animatedMovie,
      status: MediaStatus.completed,
      rating: 5.0,
      posterUrl: 'https://images.unsplash.com/photo-1595120547202-f51a44451cb7?w=400',
      year: 2023,
      genres: ['Fantasy', 'Adventure'],
      language: 'Japanese (Dub available)',
      synopsis: 'The beloved Studio Ghibli masterpiece, remastered in 4K with enhanced audio.',
      notes: 'Still perfect after all these years.',
      createdAt: DateTime(2024, 2, 14),
      updatedAt: DateTime(2024, 2, 20),
    ),
    MediaItem(
      id: 'anm-2',
      title: 'Into the Deep',
      category: MediaCategory.animatedMovie,
      status: MediaStatus.watching,
      posterUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
      year: 2024,
      genres: ['Adventure', 'Family'],
      language: 'English',
      synopsis: 'An underwater explorer and her robot companion discover a lost civilization.',
      createdAt: DateTime(2024, 7, 1),
      updatedAt: DateTime(2024, 8, 18),
    ),
    MediaItem(
      id: 'anm-3',
      title: 'Arcane Chronicles',
      category: MediaCategory.animatedMovie,
      status: MediaStatus.planToWatch,
      posterUrl: 'https://images.unsplash.com/photo-1550684376-efcbd6e3f031?w=400',
      year: 2024,
      genres: ['Fantasy', 'Action'],
      language: 'English',
      synopsis: 'A standalone animated film set in the world of the beloved series.',
      createdAt: DateTime(2024, 8, 10),
      updatedAt: DateTime(2024, 8, 10),
    ),
    MediaItem(
      id: 'anm-4',
      title: 'Luminos',
      category: MediaCategory.animatedMovie,
      status: MediaStatus.completed,
      rating: 4.0,
      posterUrl: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=400',
      year: 2023,
      genres: ['Drama', 'Family'],
      language: 'English',
      synopsis: 'A touching story about a bioluminescent creature and a lonely lighthouse keeper.',
      createdAt: DateTime(2024, 4, 3),
      updatedAt: DateTime(2024, 4, 20),
    ),
    MediaItem(
      id: 'anm-5',
      title: 'Cloud Atlas Animated',
      category: MediaCategory.animatedMovie,
      status: MediaStatus.dropped,
      posterUrl: 'https://images.unsplash.com/photo-1501630834273-4b5604d2ee31?w=400',
      year: 2022,
      genres: ['Drama', 'Sci-Fi'],
      language: 'English',
      synopsis: 'An animated retelling of the interconnected lives across centuries.',
      notes: 'Wasn\'t for me.',
      createdAt: DateTime(2023, 11, 5),
      updatedAt: DateTime(2023, 12, 1),
    ),

    // ── Anime ─────────────────────────────────────────────────────────────
    MediaItem(
      id: 'ani-1',
      title: 'Neon Genesis: Ascend',
      category: MediaCategory.anime,
      status: MediaStatus.watching,
      rating: 4.5,
      posterUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400',
      year: 2024,
      genres: ['Sci-Fi', 'Mecha', 'Psychological'],
      language: 'Japanese (Dub available)',
      synopsis: 'In 2142, a disgraced detective and a decommissioned android navigate neon-soaked mega-structures to uncover a memory-erasing AI conspiracy.',
      totalEpisodes: 24,
      episodesWatched: 12,
      notes: 'The worldbuilding is incredible. Episode 8 was a masterpiece.',
      createdAt: DateTime(2024, 6, 15),
      updatedAt: DateTime(2024, 8, 21),
    ),
    MediaItem(
      id: 'ani-2',
      title: 'Attack on Void',
      category: MediaCategory.anime,
      status: MediaStatus.completed,
      rating: 4.5,
      posterUrl: 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=400',
      year: 2023,
      genres: ['Action', 'Dark Fantasy'],
      language: 'Japanese (Sub only)',
      synopsis: 'Humanity\'s last survivors must confront the void that consumes all light.',
      totalEpisodes: 12,
      episodesWatched: 12,
      notes: 'The ending hit differently. Recommend sub over dub.',
      createdAt: DateTime(2023, 10, 1),
      updatedAt: DateTime(2024, 1, 15),
    ),
    MediaItem(
      id: 'ani-3',
      title: 'Demon\'s Horizon',
      category: MediaCategory.anime,
      status: MediaStatus.planToWatch,
      posterUrl: 'https://images.unsplash.com/photo-1583835746434-cf1534674b41?w=400',
      year: 2024,
      genres: ['Action', 'Supernatural'],
      language: 'Japanese',
      totalEpisodes: 26,
      episodesWatched: 0,
      createdAt: DateTime(2024, 8, 1),
      updatedAt: DateTime(2024, 8, 1),
    ),
    MediaItem(
      id: 'ani-4',
      title: 'Fullmetal Reverie',
      category: MediaCategory.anime,
      status: MediaStatus.onHold,
      rating: 3.5,
      posterUrl: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=400',
      year: 2022,
      genres: ['Adventure', 'Fantasy'],
      language: 'Japanese (Dub available)',
      synopsis: 'Two brothers seek the philosopher\'s stone in a world where alchemy is a science.',
      totalEpisodes: 64,
      episodesWatched: 30,
      notes: 'On hold — will pick up after finals.',
      createdAt: DateTime(2024, 1, 5),
      updatedAt: DateTime(2024, 5, 20),
    ),
    MediaItem(
      id: 'ani-5',
      title: 'My Hero: Ascendant',
      category: MediaCategory.anime,
      status: MediaStatus.watching,
      rating: 4.0,
      posterUrl: 'https://images.unsplash.com/photo-1601850494422-3cf14624b0b3?w=400',
      year: 2024,
      genres: ['Action', 'Superhero'],
      language: 'Japanese (Dub available)',
      synopsis: 'The next generation of heroes rises to face a new era of villainy.',
      totalEpisodes: 25,
      episodesWatched: 8,
      createdAt: DateTime(2024, 7, 5),
      updatedAt: DateTime(2024, 8, 22),
    ),
  ];

  // ── CRUD ──────────────────────────────────────────────────────────────────

  @override
  Future<List<MediaItem>> getAll() async => List.unmodifiable(_items);

  @override
  Future<List<MediaItem>> getByCategory(MediaCategory category) async =>
      _items.where((i) => i.category == category).toList();

  @override
  Future<List<MediaItem>> getByStatus(MediaStatus status) async =>
      _items.where((i) => i.status == status).toList();

  @override
  Future<MediaItem?> getById(String id) async =>
      _items.where((i) => i.id == id).firstOrNull;

  @override
  Future<MediaItem> add(MediaItem item) async {
    final newItem = item.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.add(newItem);
    return newItem;
  }

  @override
  Future<MediaItem> update(MediaItem item) async {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx == -1) throw Exception('MediaItem not found: ${item.id}');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _items[idx] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((i) => i.id == id);
  }

  @override
  Future<List<MediaItem>> getContinueWatching({int limit = 5}) async {
    final watching = _items
        .where((i) => i.status == MediaStatus.watching)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return watching.take(limit).toList();
  }
}
