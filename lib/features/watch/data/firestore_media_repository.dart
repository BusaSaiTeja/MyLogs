import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/watch/domain/media_repository.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:uuid/uuid.dart';

class FirestoreMediaRepository implements MediaRepository {
  FirestoreMediaRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('media');
  }

  @override
  Future<List<MediaItem>> getAll() async {
    final snapshot = await _collection().orderBy('updatedAt', descending: true).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<List<MediaItem>> getByCategory(MediaCategory category) async {
    final snapshot = await _collection()
        .where('category', isEqualTo: category.name)
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<List<MediaItem>> getByStatus(MediaStatus status) async {
    final snapshot = await _collection()
        .where('status', isEqualTo: status.name)
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<MediaItem?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<MediaItem> add(MediaItem item) async {
    final id = item.id.trim().isEmpty ? const Uuid().v4() : item.id;
    final itemWithId = item.copyWith(id: id);
    await _collection().doc(id).set(itemWithId.toJson());
    return itemWithId;
  }

  @override
  Future<MediaItem> update(MediaItem item) async {
    final updated = item.copyWith(updatedAt: DateTime.now());
    await _collection().doc(item.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  @override
  Future<List<MediaItem>> getContinueWatching({int limit = 5}) async {
    final snapshot = await _collection()
        .where('status', isEqualTo: MediaStatus.watching.name)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  MediaItem _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    data['id'] = doc.id;
    return MediaItem.fromJson(data);
  }
}
