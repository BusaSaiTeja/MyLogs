import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_logs/core/services/auth_service.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';
import 'package:my_logs/features/reminders/domain/reminder_repository.dart';
import 'package:uuid/uuid.dart';

class FirestoreReminderRepository implements ReminderRepository {
  FirestoreReminderRepository({
    FirebaseFirestore? firestore,
    AuthService? authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _authService.currentUserId ?? 'anonymous';
    return _firestore.collection('users').doc(uid).collection('reminders');
  }

  @override
  Future<List<ReminderItem>> getAll() async {
    final snapshot = await _collection().orderBy('scheduledTime', descending: false).get();
    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  @override
  Future<ReminderItem?> getById(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  @override
  Future<ReminderItem> add(ReminderItem item) async {
    final id = item.id.trim().isEmpty ? const Uuid().v4() : item.id;
    final itemWithId = item.copyWith(id: id);
    await _collection().doc(id).set(itemWithId.toJson());
    return itemWithId;
  }

  @override
  Future<ReminderItem> update(ReminderItem item) async {
    final updated = item.copyWith(updatedAt: DateTime.now());
    await _collection().doc(item.id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _collection().doc(id).delete();
  }

  @override
  Future<ReminderItem> toggleEnabled(String id) async {
    final doc = await _collection().doc(id).get();
    if (!doc.exists) {
      throw Exception('Reminder with ID $id not found');
    }
    final existing = _fromFirestore(doc);
    final updated = existing.copyWith(
      isEnabled: !existing.isEnabled,
      updatedAt: DateTime.now(),
    );
    await _collection().doc(id).set(updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  @override
  Future<List<ReminderItem>> getTodayReminders() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final snapshot = await _collection()
        .where('isEnabled', isEqualTo: true)
        .where('scheduledTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('scheduledTime', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .get();

    return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  ReminderItem _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    data['id'] = doc.id;
    return ReminderItem.fromJson(data);
  }
}
