import 'package:flutter/material.dart';

class WorkspaceThemeData {
  static const Map<String, IconData> availableIcons = {
    'person_outline_rounded': Icons.person_outline_rounded,
    'work_outline_rounded': Icons.work_outline_rounded,
    'school_outlined': Icons.school_outlined,
    'laptop_mac_rounded': Icons.laptop_mac_rounded,
    'sports_esports_outlined': Icons.sports_esports_outlined,
    'palette_outlined': Icons.palette_outlined,
    'rocket_launch_outlined': Icons.rocket_launch_outlined,
    'favorite_outline_rounded': Icons.favorite_outline_rounded,
    'folder_outlined': Icons.folder_outlined,
    'auto_stories_outlined': Icons.auto_stories_outlined,
    'lightbulb_outline_rounded': Icons.lightbulb_outline_rounded,
    'code_rounded': Icons.code_rounded,
  };

  static const List<int> availableColors = [
    0xFF4F46E5, // Indigo
    0xFF8B5CF6, // Purple
    0xFFEC4899, // Pink
    0xFFEF4444, // Red
    0xFFF59E0B, // Amber
    0xFF10B981, // Emerald
    0xFF06B6D4, // Cyan
    0xFF0EA5E9, // Sky Blue
    0xFF3B82F6, // Blue
    0xFF64748B, // Slate
  ];

  static IconData getIcon(String iconName) {
    return availableIcons[iconName] ?? Icons.folder_outlined;
  }
}
