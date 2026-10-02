import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:my_logs/features/auth/presentation/login_screen.dart';
import 'package:my_logs/features/auth/presentation/register_screen.dart';
import 'package:my_logs/features/auth/presentation/verify_email_screen.dart';
import 'package:my_logs/features/profile/presentation/profile_screen.dart';
import 'package:my_logs/features/workspaces/presentation/feature_marketplace_screen.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/notion_workspace_drawer.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (BuildContext context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;
    final bool loggedIn = user != null;
    final bool isGoogleOrOAuth =
        user?.providerData.any((p) => p.providerId == 'google.com') ?? false;
    final bool isAnonymous = user?.isAnonymous ?? false;
    final bool isEmailVerified = user?.emailVerified ?? false;

    // Google, anonymous, and verified email users bypass the verification screen
    final bool isVerified = !loggedIn || isAnonymous || isGoogleOrOAuth || isEmailVerified;

    final String loc = state.matchedLocation;
    final bool isAuthRoute = loc == '/login' || loc == '/register';
    final bool isVerifyRoute = loc == '/verify-email';

    if (!loggedIn && !isAuthRoute) return '/login';
    if (loggedIn && !isVerified && !isVerifyRoute) return '/verify-email';
    if (loggedIn && isVerified && (isAuthRoute || isVerifyRoute)) return '/';
    return null;
  },
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
      path: '/marketplace',
      builder: (context, state) => const FeatureMarketplaceScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
  ],
);

// ── Main Shell (bottom navigation bar) ────────────────────────────────────────
class _MainShell extends StatelessWidget {
  const _MainShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isHome = navigationShell.currentIndex == 0;

    return PopScope(
      canPop: isHome,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (!isHome) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        key: rootScaffoldKey,
        drawer: const NotionWorkspaceDrawer(),
        body: navigationShell,
      ),
    );
  }
}

