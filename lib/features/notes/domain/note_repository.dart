import 'package:my_logs/features/notes/domain/models/note_item.dart';

/// Abstract repository interface for notes.
abstract class NoteRepository {
  Future<List<NoteItem>> getAll();
  Future<NoteItem?> getById(String id);
  Future<NoteItem> add(NoteItem item);
  Future<NoteItem> update(NoteItem item);
  Future<void> delete(String id);
}
