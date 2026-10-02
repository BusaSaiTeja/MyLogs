import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/features/learning_paths/application/learning_path_providers.dart';
import 'package:my_logs/features/notes/application/note_providers.dart';
import 'package:my_logs/features/read/application/book_providers.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/tasks/application/task_providers.dart';
import 'package:my_logs/features/watch/application/media_providers.dart';
import 'package:my_logs/features/workspaces/application/workspace_providers.dart';
import 'package:my_logs/features/workspaces/domain/models/workspace_item.dart';
import 'package:my_logs/features/workspaces/presentation/widgets/workspace_switcher_modal.dart';

/// Global key to control the root scaffold drawer from anywhere in the application.
final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();

class NotionWorkspaceDrawer extends ConsumerStatefulWidget {
  const NotionWorkspaceDrawer({super.key});

  @override
  ConsumerState<NotionWorkspaceDrawer> createState() => _NotionWorkspaceDrawerState();
}

class _NotionWorkspaceDrawerState extends ConsumerState<NotionWorkspaceDrawer> {
  // App Consistent Palette (Light mode matching app theme)
  static const Color _bg = AppColors.surfaceContainerLowest; // Pure white / 0xFFFFFFFF
  static const Color _surface = AppColors.surfaceContainerLow; // 0xFFF2F4F6
  static const Color _border = Color(0xFFE2E8F0); // Subtle divider & border
  static const Color _textPrimary = AppColors.onSurface; // 0xFF191C1E
  static const Color _textSecondary = AppColors.onSurfaceVariant; // 0xFF464555

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final activeWs = ref.watch(activeWorkspaceProvider);

    final notes = ref.watch(workspaceFilteredNotesProvider).valueOrNull ?? [];
    final tasks = ref.watch(todayTasksProvider);
    final reminders = ref.watch(todayRemindersProvider);
    final books = ref.watch(workspaceFilteredBooksProvider);
    final media = ref.watch(workspaceFilteredMediaProvider);
    final paths = ref.watch(workspaceFilteredLearningPathsProvider).valueOrNull ?? [];

    final enabledKeys = activeWs?.enabledFeatures ??
        ['notes', 'tasks', 'reminders', 'read', 'watch', 'learning_paths'];

    final currentLoc = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: _bg,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top Header (Workspace Pill + Quick Nav Pills) ──────────────
            _buildTopHeader(user, activeWs),

            // ── Scrollable Workspace Content ───────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  // ── Home Navigation Item ─────────────────────────────────
                  _buildGmailNavItem(
                    context: context,
                    title: 'Home',
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    color: AppColors.primary,
                    count: 0,
                    isActive: currentLoc == '/' || currentLoc.isEmpty,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/');
                    },
                  ),

                  const SizedBox(height: 4),
                  const Divider(color: _border, height: 16, thickness: 1),
                  const SizedBox(height: 2),

                  // ── Section Title: Active Features ───────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ACTIVE FEATURES',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          '${enabledKeys.length} enabled',
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── Gmail-Style Navigation List ──────────────────────────
                  if (enabledKeys.contains('notes'))
                    _buildGmailNavItem(
                      context: context,
                      title: 'Notes',
                      icon: Icons.description_outlined,
                      activeIcon: Icons.description_rounded,
                      color: const Color(0xFF3B82F6),
                      count: notes.length,
                      isActive: currentLoc.startsWith('/notes'),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/notes');
                      },
                    ),

                  if (enabledKeys.contains('tasks'))
                    _buildGmailNavItem(
                      context: context,
                      title: 'Tasks',
                      icon: Icons.check_box_outlined,
                      activeIcon: Icons.check_box_rounded,
                      color: const Color(0xFF10B981),
                      count: tasks.length,
                      isActive: currentLoc.startsWith('/tasks'),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/tasks');
                      },
                    ),

                  if (enabledKeys.contains('reminders'))
                    _buildGmailNavItem(
                      context: context,
                      title: 'Reminders',
                      icon: Icons.alarm_rounded,
                      activeIcon: Icons.alarm_on_rounded,
                      color: const Color(0xFFF59E0B),
                      count: reminders.length,
                      isActive: currentLoc.startsWith('/reminders'),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/reminders');
                      },
                    ),

                  if (enabledKeys.contains('read'))
                    _buildGmailNavItem(
                      context: context,
                      title: 'Read Tracker',
                      icon: Icons.menu_book_outlined,
                      activeIcon: Icons.menu_book_rounded,
                      color: const Color(0xFF8B5CF6),
                      count: books.length,
                      isActive: currentLoc.startsWith('/read'),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/read');
                      },
                    ),

                  if (enabledKeys.contains('watch'))
                    _buildGmailNavItem(
                      context: context,
                      title: 'Watch Hub',
                      icon: Icons.movie_outlined,
                      activeIcon: Icons.movie_rounded,
                      color: const Color(0xFFEC4899),
                      count: media.length,
                      isActive: currentLoc.startsWith('/watch'),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/watch');
                      },
                    ),

                  if (enabledKeys.contains('learning_paths'))
                    _buildGmailNavItem(
                      context: context,
                      title: 'Learning Paths',
                      icon: Icons.alt_route_rounded,
                      activeIcon: Icons.alt_route_rounded,
                      color: const Color(0xFF06B6D4),
                      count: paths.length,
                      isActive: currentLoc.startsWith('/learning-paths'),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/learning-paths');
                      },
                    ),

                  const SizedBox(height: 4),
                  const Divider(color: _border, height: 16, thickness: 1),

                  // ── Feature Marketplace Navigation Item (below active features) ──
                  _buildMarketplaceNavItem(context),

                  // ── Log Out Navigation Item ──────────────────────────────
                  _buildLogoutNavItem(context),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // ── Bottom Fixed Search Pill & Quick New Button ─────────────────
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  // ── Top Header (Notion App Logo + Workspace Pill) ──────────────────────────
  Widget _buildTopHeader(User? user, WorkspaceItem? activeWs) {
    final wsName = activeWs?.name ?? 'Personal';
    final wsColor = Color(activeWs?.colorValue ?? 0xFF4F46E5);
    final wsInitial = wsName.isNotEmpty ? wsName[0].toUpperCase() : 'P';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      child: Row(
        children: [
          // Stylized Notion / App Icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.sticky_note_2_rounded, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),

          // Workspace Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showNotionWorkspaceDropdown(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _border, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: wsColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          wsInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Text(
                        wsName,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: _textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Notion-Style Workspace Dropdown Menu (Image 2) ─────────────────────────
  void _showNotionWorkspaceDropdown(BuildContext context) {
    final activeWs = ref.read(activeWorkspaceProvider);
    final allWorkspaces = ref.read(workspaceListProvider).valueOrNull ?? [];
    final activeId = ref.read(activeWorkspaceIdProvider).valueOrNull;
    final user = FirebaseAuth.instance.currentUser;

    final notes = ref.read(workspaceFilteredNotesProvider).valueOrNull ?? [];
    final tasks = ref.read(todayTasksProvider);
    final reminders = ref.read(todayRemindersProvider);
    final books = ref.read(workspaceFilteredBooksProvider);
    final media = ref.read(workspaceFilteredMediaProvider);
    final paths = ref.read(workspaceFilteredLearningPathsProvider).valueOrNull ?? [];
    final totalCount = notes.length + tasks.length + reminders.length + books.length + media.length + paths.length;

    final wsName = activeWs?.name ?? 'Personal';
    final wsColor = Color(activeWs?.colorValue ?? 0xFF4F46E5);
    final wsInitial = wsName.isNotEmpty ? wsName[0].toUpperCase() : 'P';
    final email = user?.email ?? 'siddusaiteja13@gmail.com';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) {
        return Dialog(
          alignment: Alignment.topLeft,
          insetPadding: const EdgeInsets.only(left: 14, top: 48, right: 36),
          backgroundColor: _bg,
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _border, width: 1),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top Header Tile (Big Initial + Workspace Title) ───────
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: wsColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            wsInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wsName,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Free Plan · $totalCount logged',
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Action Links ──────────────────────────────────────────
                  _buildDropdownAction(
                    icon: Icons.arrow_circle_up_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Upgrade / Workspace Stats',
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _showStatsDialog(notes.length, tasks.length, reminders.length, books.length, media.length, paths.length);
                    },
                  ),
                  _buildDropdownAction(
                    icon: Icons.storefront_outlined,
                    iconColor: AppColors.primary,
                    title: 'Feature Marketplace',
                    onTap: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                      context.push('/marketplace');
                    },
                  ),
                  _buildDropdownAction(
                    icon: Icons.settings_outlined,
                    iconColor: _textSecondary,
                    title: 'Settings',
                    onTap: () {
                      Navigator.of(ctx).pop();
                      WorkspaceSwitcherModal.show(context);
                    },
                  ),
                  _buildDropdownAction(
                    icon: Icons.person_outline_rounded,
                    iconColor: _textSecondary,
                    title: 'Add account',
                    onTap: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                      context.push('/profile');
                    },
                  ),

                  const SizedBox(height: 8),
                  const Divider(color: _border, height: 1, thickness: 1),
                  const SizedBox(height: 8),

                  // ── User Email Header ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      email,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── Workspaces List (matching Image 2) ─────────────────────
                  ...allWorkspaces.map((ws) {
                    final isCurrent = ws.id == activeId || (activeId == null && ws.isDefault);
                    final col = Color(ws.colorValue);
                    final initial = ws.name.isNotEmpty ? ws.name[0].toUpperCase() : 'W';

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ref.read(activeWorkspaceIdProvider.notifier).setActive(ws.id);
                          Navigator.of(ctx).pop();
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(
                            color: isCurrent ? _surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ws.name,
                                  style: TextStyle(
                                    color: isCurrent ? _textPrimary : _textSecondary,
                                    fontSize: 13,
                                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCurrent)
                                const Icon(Icons.check_rounded, color: _textPrimary, size: 18),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 4),

                  // ── + New workspace ───────────────────────────────────────
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        WorkspaceSwitcherModal.show(context);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Row(
                          children: [
                            Icon(Icons.add_rounded, color: AppColors.primary, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'New workspace',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  const Divider(color: _border, height: 1, thickness: 1),
                  const SizedBox(height: 4),

                  // ── Log out ───────────────────────────────────────────────
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _confirmLogout(context);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Row(
                          children: [
                            Icon(Icons.logout_rounded, color: _textSecondary, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Log out',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownAction({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 🧩 Feature Marketplace Navigation Item (Clean List Item) ──────────────
  Widget _buildMarketplaceNavItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            context.push('/marketplace');
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  color: _textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Feature Marketplace',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 13,
                        color: _textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Customize',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 🚪 Log Out Navigation Item ─────────────────────────────────────────────
  Widget _buildLogoutNavItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _confirmLogout(context),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFDC2626),
                  size: 20,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 🚪 Centralized Logout Confirmation Dialog ───────────────────────────────
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 22),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            fontSize: 14,
            color: _textSecondary,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: _textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop(); // close dialog
              Navigator.of(context).pop(); // close drawer
              await FirebaseAuth.instance.signOut();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Gmail-Style Navigation Item ────────────────────────────────────────────
  Widget _buildGmailNavItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required IconData activeIcon,
    required Color color,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: isActive
                  ? color.withValues(alpha: 0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: isActive
                  ? Border.all(color: color.withValues(alpha: 0.35), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? color : _textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isActive ? color : _textPrimary,
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? color : _surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isActive ? Colors.white : _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom Fixed Bar (Search + Quick New) ──────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border, width: 1)),
      ),
      child: Row(
        children: [
          // Search Pill
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                context.go('/tasks');
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _border, width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded, size: 18, color: _textSecondary),
                    SizedBox(width: 8),
                    Text(
                      'Search logs / Ask AI',
                      style: TextStyle(color: _textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Quick New Action Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                _showQuickAddMenu(context);
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                title: const Text('New Note', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500)),
                onTap: () {
                  ctx.pop();
                  context.push('/notes/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_box_outlined, color: AppColors.primary),
                title: const Text('New Task', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500)),
                onTap: () {
                  ctx.pop();
                  context.push('/tasks/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.alarm_rounded, color: AppColors.primary),
                title: const Text('New Reminder', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500)),
                onTap: () {
                  ctx.pop();
                  context.push('/reminders/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.book_outlined, color: AppColors.primary),
                title: const Text('New Book Log', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500)),
                onTap: () {
                  ctx.pop();
                  context.push('/read/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.movie_outlined, color: AppColors.primary),
                title: const Text('New Watch Log', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500)),
                onTap: () {
                  ctx.pop();
                  context.push('/watch/movies/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.alt_route_rounded, color: AppColors.primary),
                title: const Text('New Learning Path', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500)),
                onTap: () {
                  ctx.pop();
                  context.push('/learning-paths/add');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatsDialog(int notes, int tasks, int reminders, int books, int media, int paths) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Workspace Stats', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statItem('Notes', notes),
            _statItem('Tasks', tasks),
            _statItem('Reminders', reminders),
            _statItem('Books', books),
            _statItem('Movies & Anime', media),
            _statItem('Learning Paths', paths),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _textSecondary)),
          Text('$count', style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
