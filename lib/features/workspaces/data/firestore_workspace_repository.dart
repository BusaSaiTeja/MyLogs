import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/workspaces/domain/models/workspace_item.dart';
import 'package:my_logs/features/workspaces/domain/workspace_repository.dart';
import 'package:uuid/uuid.dart';

class FirestoreWorkspaceRepository implements WorkspaceRepository {
  FirestoreWorkspaceRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('workspaces');
  }

  @override
  Future<List<WorkspaceItem>> getAll() async {
    final snapshot = await _collection().orderBy('createdAt', descending: false).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<WorkspaceItem?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<WorkspaceItem> add(WorkspaceItem workspace) async {
    final id = workspace.id.trim().isEmpty ? const Uuid().v4() : workspace.id;
    final itemWithId = workspace.copyWith(id: id);
    await _collection().doc(id).set(itemWithId.toJson());
    return itemWithId;
  }

  @override
  Future<WorkspaceItem> update(WorkspaceItem workspace) async {
    final updated = workspace.copyWith(updatedAt: DateTime.now());
    await _collection().doc(workspace.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  WorkspaceItem _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = Map<String, dynamic>.from(doc.data()!);
    data['id'] = doc.id;
    return WorkspaceItem.fromJson(data);
  }
}
