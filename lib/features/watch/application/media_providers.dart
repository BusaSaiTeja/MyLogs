import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/features/watch/data/mock_media_repository.dart';
import 'package:my_logs/features/watch/domain/media_repository.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
/// Phase 2: swap MockMediaRepository → FirestoreMediaRepository here only.
final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MockMediaRepository();
});

// ── Stats for Watch Hub cards ─────────────────────────────────────────────────
class WatchHubStats {
  final int movieCount;
  final int animatedCount;
  final int animeCount;
  const WatchHubStats({
    required this.movieCount,
    required this.animatedCount,
    required this.animeCount,
  });
}

// ── Notifiers ─────────────────────────────────────────────────────────────────

/// Holds the full media list and supports CRUD operations.
class MediaListNotifier extends AsyncNotifier<List<MediaItem>> {
  MediaRepository get _repo => ref.read(mediaRepositoryProvider);

  @override
  Future<List<MediaItem>> build() async {
    return _repo.getAll();
  }

  Future<void> add(MediaItem item) async {
    final created = await _repo.add(item);
    state = AsyncData([...?state.valueOrNull, created]);
  }

  Future<void> updateItem(MediaItem item) async {
    final updated = await _repo.update(item);
    state = AsyncData(
      (state.valueOrNull ?? []).map((m) => m.id == updated.id ? updated : m).toList(),
    );
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = AsyncData(
      (state.valueOrNull ?? []).where((m) => m.id != id).toList(),
    );
  }

  Future<void> updateStatus(String id, MediaStatus status) async {
    final existing = (state.valueOrNull ?? []).firstWhere((m) => m.id == id);
    await updateItem(existing.copyWith(status: status));
  }

  Future<void> updateRating(String id, double rating) async {
    final existing = (state.valueOrNull ?? []).firstWhere((m) => m.id == id);
    await updateItem(existing.copyWith(rating: rating));
  }

  Future<void> incrementEpisode(String id) async {
    final existing = (state.valueOrNull ?? []).firstWhere((m) => m.id == id);
    final newCount = (existing.episodesWatched + 1)
        .clamp(0, existing.totalEpisodes ?? 9999);
    await updateItem(existing.copyWith(episodesWatched: newCount));
  }

  Future<void> updateNotes(String id, String notes) async {
    final existing = (state.valueOrNull ?? []).firstWhere((m) => m.id == id);
    await updateItem(existing.copyWith(notes: notes));
  }
}

final mediaListProvider =
    AsyncNotifierProvider<MediaListNotifier, List<MediaItem>>(
  MediaListNotifier.new,
);

// ── Derived / Filtered Providers ──────────────────────────────────────────────

/// Media items filtered by category.
final mediaByCategory = Provider.family<AsyncValue<List<MediaItem>>, MediaCategory>((ref, cat) {
  return ref.watch(mediaListProvider).whenData(
        (items) => items.where((m) => m.category == cat).toList(),
      );
});

/// Media items filtered by category AND status — used for tabs.
final mediaByCategoryAndStatus =
    Provider.family<List<MediaItem>, (MediaCategory, MediaStatus)>((ref, args) {
  final (cat, status) = args;
  return ref.watch(mediaListProvider).valueOrNull?.where(
            (m) => m.category == cat && m.status == status,
          ).toList() ??
      [];
});

/// Single item by id — used by MediaDetailScreen.
final mediaByIdProvider = Provider.family<MediaItem?, String>((ref, id) {
  return ref
      .watch(mediaListProvider)
      .valueOrNull
      ?.where((m) => m.id == id)
      .firstOrNull;
});

/// Live counts for the Watch Hub cards.
final watchHubStatsProvider = Provider<WatchHubStats>((ref) {
  final items = ref.watch(mediaListProvider).valueOrNull ?? [];
  return WatchHubStats(
    movieCount: items.where((m) => m.category == MediaCategory.movie).length,
    animatedCount: items.where((m) => m.category == MediaCategory.animatedMovie).length,
    animeCount: items.where((m) => m.category == MediaCategory.anime).length,
  );
});

/// Items currently being watched (for Home screen "Continue Watching" section).
final continueWatchingProvider = Provider<List<MediaItem>>((ref) {
  final items = ref.watch(mediaListProvider).valueOrNull ?? [];
  return (items.where((m) => m.status == MediaStatus.watching).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)))
      .take(5)
      .toList();
});
