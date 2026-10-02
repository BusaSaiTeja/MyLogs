import 'package:flutter/material.dart';

class FeatureDefinition {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;

  const FeatureDefinition({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
  });
}

const List<FeatureDefinition> availableAppFeatures = [
  FeatureDefinition(
    key: 'notes',
    title: 'Notes',
    description: 'Capture thoughts, rich text, category tags & pinned ideas',
    icon: Icons.description_outlined,
    color: Color(0xFF3B82F6),
    category: 'Productivity',
  ),
  FeatureDefinition(
    key: 'tasks',
    title: 'Tasks',
    description: 'Track today & upcoming to-dos with priorities & checklists',
    icon: Icons.check_box_outlined,
    color: Color(0xFF10B981),
    category: 'Productivity',
  ),
  FeatureDefinition(
    key: 'reminders',
    title: 'Reminders',
    description: 'Exact alarms, scheduled alerts & repeating habit reminders',
    icon: Icons.alarm_rounded,
    color: Color(0xFFF59E0B),
    category: 'Productivity',
  ),
  FeatureDefinition(
    key: 'read',
    title: 'Read Tracker',
    description: 'Track reading progress, Google Books search & ratings',
    icon: Icons.menu_book_outlined,
    color: Color(0xFF8B5CF6),
    category: 'Knowledge & Culture',
  ),
  FeatureDefinition(
    key: 'watch',
    title: 'Watch Hub',
    description: 'Movies, anime & series tracking via TMDB & AniList',
    icon: Icons.movie_outlined,
    color: Color(0xFFEC4899),
    category: 'Entertainment',
  ),
  FeatureDefinition(
    key: 'learning_paths',
    title: 'Learning Paths',
    description: 'Create multi-step learning roadmaps with milestones & resources',
    icon: Icons.alt_route_rounded,
    color: Color(0xFF06B6D4),
    category: 'Knowledge & Culture',
  ),
];
