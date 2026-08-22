import 'package:uuid/uuid.dart';
import 'package:my_logs/features/notes/domain/models/note_item.dart';
import 'package:my_logs/features/notes/domain/note_repository.dart';

/// In-memory mock implementation of [NoteRepository].
class MockNoteRepository implements NoteRepository {
  MockNoteRepository() {
    _items = List.from(_seed);
  }

  static const _uuid = Uuid();
  late List<NoteItem> _items;

  static final List<NoteItem> _seed = [
    NoteItem(
      id: 'note-1',
      title: 'Project Ideas',
      content:
          'Redesign the landing page to focus on the new fluid-inset grid. Consider adding more generous whitespace between the feature sections to improve readability and flow. Also explore a dark mode variant.',
      tags: ['design', 'work'],
      createdAt: DateTime(2024, 10, 24),
      updatedAt: DateTime(2024, 10, 24),
    ),
    NoteItem(
      id: 'note-2',
      title: 'Meeting Notes: Q4 Planning',
      content:
          'Discussed targets for the upcoming quarter. Main focus will be on user retention and improving the onboarding experience for new signups. Need to draft a detailed proposal by next week. Key metrics: DAU +20%, churn <5%.',
      tags: ['work', 'meetings'],
      createdAt: DateTime(2024, 10, 22),
      updatedAt: DateTime(2024, 10, 22),
    ),
    NoteItem(
      id: 'note-3',
      title: 'Grocery List',
      content: '- Almond milk\n- Spinach\n- Avocados\n- Coffee beans (light roast)\n- Greek yogurt\n- Sourdough bread',
      tags: ['personal'],
      createdAt: DateTime(2024, 10, 21),
      updatedAt: DateTime(2024, 10, 21),
    ),
    NoteItem(
      id: 'note-4',
      title: 'Design Inspiration',
      content:
          'Found some great examples of high-utility minimalism in recent productivity apps. Need to incorporate more tonal layering instead of heavy shadows for depth. Key references: Linear, Craft, Things 3.',
      tags: ['design', 'inspiration'],
      createdAt: DateTime(2024, 10, 19),
      updatedAt: DateTime(2024, 10, 19),
    ),
    NoteItem(
      id: 'note-5',
      title: 'Book Recommendations',
      content:
          '"The Design of Everyday Things" by Don Norman.\n"Thinking, Fast and Slow" by Daniel Kahneman.\n"Atomic Habits" by James Clear.\n"Deep Work" by Cal Newport.',
      tags: ['books', 'learning'],
      createdAt: DateTime(2024, 10, 15),
      updatedAt: DateTime(2024, 10, 15),
    ),
    NoteItem(
      id: 'note-6',
      title: 'Flutter Architecture Notes',
      content:
          'Feature-first architecture with domain/data/application/presentation layers. Riverpod for state, go_router for navigation, freezed for models. Never let widgets import data layer directly.',
      tags: ['coding', 'flutter'],
      createdAt: DateTime(2024, 10, 10),
      updatedAt: DateTime(2024, 10, 20),
    ),
  ];

  @override
  Future<List<NoteItem>> getAll() async {
    final sorted = List<NoteItem>.from(_items)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  @override
  Future<NoteItem?> getById(String id) async =>
      _items.where((n) => n.id == id).firstOrNull;

  @override
  Future<NoteItem> add(NoteItem item) async {
    final newItem = item.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _items.add(newItem);
    return newItem;
  }

  @override
  Future<NoteItem> update(NoteItem item) async {
    final idx = _items.indexWhere((n) => n.id == item.id);
    if (idx == -1) throw Exception('NoteItem not found: ${item.id}');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _items[idx] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((n) => n.id == id);
  }
}
