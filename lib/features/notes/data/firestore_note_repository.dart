import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';
import 'package:my_logs/features/notes/domain/note_repository.dart';
import 'package:uuid/uuid.dart';

class FirestoreNoteRepository implements NoteRepository {
  FirestoreNoteRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('notes');
  }

  @override
  Future<List<NoteItem>> getAll() async {
    final snapshot = await _collection().orderBy('updatedAt', descending: true).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<NoteItem?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<NoteItem> add(NoteItem item) async {
    final id = item.id.trim().isEmpty ? const Uuid().v4() : item.id;
    final itemWithId = item.copyWith(id: id);
    await _collection().doc(id).set(itemWithId.toJson());
    return itemWithId;
  }

  @override
  Future<NoteItem> update(NoteItem item) async {
    final updated = item.copyWith(updatedAt: DateTime.now());
    await _collection().doc(item.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  NoteItem _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    data['id'] = doc.id;
    return NoteItem.fromJson(data);
  }
}
