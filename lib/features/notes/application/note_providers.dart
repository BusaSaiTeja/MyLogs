import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/features/notes/data/mock_note_repository.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';
import 'package:my_logs/features/notes/domain/note_repository.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return MockNoteRepository();
});

// ── Notifier ──────────────────────────────────────────────────────────────────
class NoteListNotifier extends AsyncNotifier<List<NoteItem>> {
  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  @override
  Future<List<NoteItem>> build() async => _repo.getAll();

  Future<void> add(NoteItem item) async {
    final created = await _repo.add(item);
    state = AsyncData([created, ...?state.valueOrNull]);
  }

  Future<void> updateItem(NoteItem item) async {
    final updated = await _repo.update(item);
    state = AsyncData(
      (state.valueOrNull ?? []).map((n) => n.id == updated.id ? updated : n).toList(),
    );
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = AsyncData((state.valueOrNull ?? []).where((n) => n.id != id).toList());
  }
}

final noteListProvider =
    AsyncNotifierProvider<NoteListNotifier, List<NoteItem>>(NoteListNotifier.new);

final noteByIdProvider = Provider.family<NoteItem?, String>((ref, id) {
  return ref.watch(noteListProvider).valueOrNull?.where((n) => n.id == id).firstOrNull;
});
