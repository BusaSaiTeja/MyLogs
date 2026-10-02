import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_logs/features/learning_paths/application/learning_path_providers.dart';
import 'package:my_logs/features/notes/application/note_providers.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';

/// Aggregated item statistics across all domains for the active workspace.
/// Encapsulates multi-domain count computations outside UI presentation (SoC / SRP).
class WorkspaceStats {
  final int notes;
  final int tasks;
  final int reminders;
  final int books;
  final int media;
  final int paths;

  const WorkspaceStats({
    this.notes = 0,
    this.tasks = 0,
    this.reminders = 0,
    this.books = 0,
    this.media = 0,
    this.paths = 0,
  });

  int get total => notes + tasks + reminders + books + media + paths;
}

final workspaceStatsProvider = Provider<WorkspaceStats>((ref) {
  final notes = ref.watch(workspaceFilteredNotesProvider).valueOrNull?.length ?? 0;
  final tasks = ref.watch(todayTasksProvider).length;
  final reminders = ref.watch(todayRemindersProvider).length;
  final books = ref.watch(workspaceFilteredBooksProvider).length;
  final media = ref.watch(workspaceFilteredMediaProvider).length;
  final paths = ref.watch(workspaceFilteredLearningPathsProvider).valueOrNull?.length ?? 0;

  return WorkspaceStats(
    notes: notes,
    tasks: tasks,
    reminders: reminders,
    books: books,
    media: media,
    paths: paths,
  );
});
