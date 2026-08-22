import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/features/home/presentation/home_screen.dart';
import 'package:my_logs/features/watch/presentation/watch_hub_screen.dart';
import 'package:my_logs/features/watch/presentation/media_list_screen.dart';
import 'package:my_logs/features/watch/presentation/media_detail_screen.dart';
import 'package:my_logs/features/watch/presentation/media_form_screen.dart';
import 'package:my_logs/features/watch/domain/models/media_item.dart';
import 'package:my_logs/features/read/presentation/read_tracker_screen.dart';
import 'package:my_logs/features/read/presentation/book_detail_screen.dart';
import 'package:my_logs/features/read/presentation/book_form_screen.dart';
import 'package:my_logs/features/tasks/presentation/tasks_screen.dart';
import 'package:my_logs/features/tasks/presentation/task_form_screen.dart';
import 'package:my_logs/features/reminders/presentation/reminders_screen.dart';
import 'package:my_logs/features/reminders/presentation/reminder_form_screen.dart';
import 'package:my_logs/features/notes/presentation/notes_screen.dart';
import 'package:my_logs/features/notes/presentation/note_detail_screen.dart';
import 'package:my_logs/features/learning_paths/presentation/learning_paths_screen.dart';
import 'package:my_logs/features/learning_paths/presentation/path_detail_screen.dart';
import 'package:my_logs/features/learning_paths/presentation/path_form_screen.dart';
import 'package:my_logs/features/profile/presentation/profile_screen.dart';
import 'package:my_logs/features/settings/presentation/settings_screen.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_typography.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _MainShell(navigationShell: shell),
      branches: [
        // ── Branch 0: Home ─────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // ── Branch 1: Watch ────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/watch',
              builder: (context, state) => const WatchHubScreen(),
              routes: [
                // Movies
                GoRoute(
                  path: 'movies',
                  builder: (context, state) =>
                      const MediaListScreen(category: MediaCategory.movie),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) =>
                          const MediaFormScreen(category: MediaCategory.movie),
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (context, state) =>
                          MediaDetailScreen(id: state.pathParameters['id']!),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          builder: (context, state) => MediaFormScreen(
                            category: MediaCategory.movie,
                            itemId: state.pathParameters['id']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Animated Movies
                GoRoute(
                  path: 'animated',
                  builder: (context, state) => const MediaListScreen(
                      category: MediaCategory.animatedMovie),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => const MediaFormScreen(
                          category: MediaCategory.animatedMovie),
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (context, state) =>
                          MediaDetailScreen(id: state.pathParameters['id']!),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          builder: (context, state) => MediaFormScreen(
                            category: MediaCategory.animatedMovie,
                            itemId: state.pathParameters['id']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Anime
                GoRoute(
                  path: 'anime',
                  builder: (context, state) =>
                      const MediaListScreen(category: MediaCategory.anime),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) =>
                          const MediaFormScreen(category: MediaCategory.anime),
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (context, state) =>
                          MediaDetailScreen(id: state.pathParameters['id']!),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          builder: (context, state) => MediaFormScreen(
                            category: MediaCategory.anime,
                            itemId: state.pathParameters['id']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ── Branch 2: Read ─────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/read',
              builder: (context, state) => const ReadTrackerScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const BookFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) =>
                      BookDetailScreen(id: state.pathParameters['id']!),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => BookFormScreen(
                        bookId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ── Branch 3: Tasks ────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              builder: (context, state) => const TasksScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const TaskFormScreen(),
                ),
                GoRoute(
                  path: ':id/edit',
                  builder: (context, state) =>
                      TaskFormScreen(taskId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),

        // ── Branch 4: Reminders ──────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reminders',
              builder: (context, state) => const RemindersScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const ReminderFormScreen(),
                ),
                GoRoute(
                  path: ':id/edit',
                  builder: (context, state) => ReminderFormScreen(
                    reminderId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Branch 4: Notes ────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notes',
              builder: (context, state) => const NotesScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) =>
                      const NoteDetailScreen(isNew: true),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => NoteDetailScreen(
                    noteId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Branch 5: Learning Paths ────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learning-paths',
              builder: (context, state) => const LearningPathsScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const PathFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => PathDetailScreen(
                    pathId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => PathFormScreen(
                        pathId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

// ── Main Shell (bottom navigation bar) ────────────────────────────────────────
class _MainShell extends StatelessWidget {
  const _MainShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _MyLogBottomNav(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
      ),
    );
  }
}

class _MyLogBottomNav extends StatelessWidget {
  const _MyLogBottomNav({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _destinations = [
    (icon: Icons.home_outlined, active: Icons.home_rounded, label: 'Home'),
    (icon: Icons.visibility_outlined, active: Icons.visibility_rounded, label: 'Watch'),
    (icon: Icons.book_outlined, active: Icons.book_rounded, label: 'Read'),
    (icon: Icons.check_circle_outline_rounded, active: Icons.check_circle_rounded, label: 'Tasks'),
    (icon: Icons.alarm_outlined, active: Icons.alarm_rounded, label: 'Reminders'),
    (icon: Icons.sticky_note_2_outlined, active: Icons.sticky_note_2_rounded, label: 'Notes'),
    (icon: Icons.alt_route_rounded, active: Icons.alt_route_rounded, label: 'Learning'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(_destinations.length, (i) {
                final dest = _destinations[i];
                final isActive = i == selectedIndex;
                return GestureDetector(
                  onTap: () => onDestinationSelected(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(9999),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? dest.active : dest.icon,
                          color: isActive
                              ? AppColors.onSecondaryContainer
                              : AppColors.onSurfaceVariant,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dest.label,
                          style: AppTypography.labelMd.copyWith(
                            color: isActive
                                ? AppColors.onSecondaryContainer
                                : AppColors.onSurfaceVariant,
                            letterSpacing: 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
