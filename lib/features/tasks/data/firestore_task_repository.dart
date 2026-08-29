import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/tasks/domain/models/task_item.dart';
import 'package:my_logs/features/tasks/domain/task_repository.dart';
import 'package:uuid/uuid.dart';

class FirestoreTaskRepository implements TaskRepository {
  FirestoreTaskRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('tasks');
  }

  @override
  Future<List<TaskItem>> getAll() async {
    final snapshot = await _collection().orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<TaskItem?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<TaskItem> add(TaskItem item) async {
    final id = item.id.trim().isEmpty ? const Uuid().v4() : item.id;
    final itemWithId = item.copyWith(id: id);
    await _collection().doc(id).set(itemWithId.toJson());
    return itemWithId;
  }

  @override
  Future<TaskItem> update(TaskItem item) async {
    final updated = item.copyWith(updatedAt: DateTime.now());
    await _collection().doc(item.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  @override
  Future<TaskItem> toggleComplete(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) {
      throw Exception('Task with ID $id not found');
    }
    final existing = _fromFirestore(doc);
    final updated = existing.copyWith(
      isCompleted: !existing.isCompleted,
      updatedAt: DateTime.now(),
    );
    await _collection().doc(id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  TaskItem _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    data['id'] = doc.id;
    return TaskItem.fromJson(data);
  }
}
