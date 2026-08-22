import 'package:my_logs/features/watch/domain/models/media_item.dart';

/// Abstract repository interface for media items.
/// Presentation and application layers depend only on this interface.
/// Phase 2: FirestoreMediaRepository implements this identically.
abstract class MediaRepository {
  /// Returns all media items for the current user.
  Future<List<MediaItem>> getAll();

  /// Returns all media items filtered by [category].
  Future<List<MediaItem>> getByCategory(MediaCategory category);

  /// Returns all media items filtered by [status].
  Future<List<MediaItem>> getByStatus(MediaStatus status);

  /// Returns the media item with [id], or null if not found.
  Future<MediaItem?> getById(String id);

  /// Adds a new item and returns it with its generated [id].
  /// Contract: the returned item always has a non-empty id.
  Future<MediaItem> add(MediaItem item);

  /// Updates an existing item. Returns the updated item.
  Future<MediaItem> update(MediaItem item);

  /// Deletes the item with [id].
  Future<void> delete(String id);

  /// Returns items with [status] == watching, ordered by updatedAt desc.
  Future<List<MediaItem>> getContinueWatching({int limit = 5});
}
