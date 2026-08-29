import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/learning_paths/domain/learning_path_repository.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';
import 'package:uuid/uuid.dart';

class FirestoreLearningPathRepository implements LearningPathRepository {
  FirestoreLearningPathRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('learning_paths');
  }

  @override
  Future<List<LearningPath>> getAll() async {
    final snapshot = await _collection().orderBy('updatedAt', descending: true).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<LearningPath?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<LearningPath> add(LearningPath path) async {
    final id = path.id.trim().isEmpty ? const Uuid().v4() : path.id;
    final pathWithId = path.copyWith(id: id);
    await _collection().doc(id).set(pathWithId.toJson());
    return pathWithId;
  }

  @override
  Future<LearningPath> update(LearningPath path) async {
    final updated = path.copyWith(updatedAt: DateTime.now());
    await _collection().doc(path.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  @override
  Future<LearningPath> toggleStep(String pathId, String stepId) async {
    final doc = await _collection().doc(pathId).get();
    if (!doc.exists) {
      throw Exception('Learning path with ID $pathId not found');
    }
    final existing = _fromFirestore(doc);
    final updatedSteps = existing.steps.map((s) {
      if (s.id == stepId) {
        return s.copyWith(isCompleted: !s.isCompleted);
      }
      return s;
    }).toList();

    final updated = existing.copyWith(
      steps: updatedSteps,
      updatedAt: DateTime.now(),
    );
    await _collection().doc(pathId).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  LearningPath _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    data['id'] = doc.id;
    return LearningPath.fromJson(data);
  }
}
