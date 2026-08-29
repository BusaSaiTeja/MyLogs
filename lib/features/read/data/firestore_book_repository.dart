import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/read/domain/book_repository.dart';
import 'package:my_logs/features/read/domain/models/book_item.dart';
import 'package:uuid/uuid.dart';

class FirestoreBookRepository implements BookRepository {
  FirestoreBookRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('books');
  }

  @override
  Future<List<BookItem>> getAll() async {
    final snapshot = await _collection().orderBy('updatedAt', descending: true).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<List<BookItem>> getByStatus(BookStatus status) async {
    if (status == BookStatus.collection) {
      final snapshot = await _collection()
          .where('isCollection', isEqualTo: true)
          .orderBy('updatedAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
    }
    final snapshot = await _collection()
        .where('status', isEqualTo: status.name)
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<BookItem?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<BookItem> add(BookItem item) async {
    final id = item.id.trim().isEmpty ? const Uuid().v4() : item.id;
    final itemWithId = item.copyWith(id: id);
    await _collection().doc(id).set(itemWithId.toJson());
    return itemWithId;
  }

  @override
  Future<BookItem> update(BookItem item) async {
    final updated = item.copyWith(updatedAt: DateTime.now());
    await _collection().doc(item.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  @override
  Future<List<BookItem>> getCurrentlyReading({int limit = 5}) async {
    final snapshot = await _collection()
        .where('status', isEqualTo: BookStatus.reading.name)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  BookItem _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = Map<String, dynamic>.from(doc.data()!);
    data['id'] = doc.id;
    // Normalize legacy 'collection' status to isCollection = true & an active reading status
    if (data['status'] == 'collection') {
      data['isCollection'] = true;
      final currentPage = data['currentPage'] as int? ?? 0;
      data['status'] = currentPage > 0 ? 'reading' : 'read';
    }
    return BookItem.fromJson(data);
  }
}
