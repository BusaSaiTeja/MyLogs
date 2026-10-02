import 'package:firebase_auth/firebase_auth.dart';

/// Single source of truth for extracting and formatting user profile information.
class UserDisplayUtils {
  const UserDisplayUtils._();

  /// Returns a clean display name for the user, falling back to email prefix or 'Member'.
  static String getDisplayName(User? user, {String defaultFallback = 'Member'}) {
    if (user == null) return defaultFallback;

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    if (user.email != null && user.email!.contains('@')) {
      final name = user.email!.split('@').first;
      if (name.isNotEmpty) {
        return name[0].toUpperCase() + name.substring(1);
      }
    }

    return defaultFallback;
  }

  /// Returns 1-2 uppercase initials from a name or user string.
  static String getInitials(String name, {String fallback = 'M'}) {
    final clean = name.trim();
    if (clean.isEmpty) return fallback;

    final parts = clean.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return clean[0].toUpperCase();
  }

  /// Returns the user's primary email address or a placeholder.
  static String getEmail(User? user, {String placeholder = 'Authenticated Member'}) {
    if (user?.email != null && user!.email!.isNotEmpty) {
      return user.email!;
    }
    return placeholder;
  }
}
