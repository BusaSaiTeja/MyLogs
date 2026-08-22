import 'package:uuid/uuid.dart';
import 'package:my_logs/features/learning_paths/domain/models/learning_path.dart';
import 'package:my_logs/features/learning_paths/domain/learning_path_repository.dart';

/// In-memory mock implementation of [LearningPathRepository].
class MockLearningPathRepository implements LearningPathRepository {
  MockLearningPathRepository() {
    _paths = List.from(_seed);
  }

  static const _uuid = Uuid();
  late List<LearningPath> _paths;

  static final List<LearningPath> _seed = [
    LearningPath(
      id: 'path-1',
      title: 'Advanced UI/UX Principles',
      description: 'Mastering interaction design and design systems.',
      steps: [
        PathStep(id: 'step-1-1', order: 1, title: 'Introduction to Fluid Typography', isCompleted: true, resourceUrl: 'https://web.dev/learn/design/typography'),
        PathStep(id: 'step-1-2', order: 2, title: 'Tonal Elevation Systems', description: 'Replacing shadows with color depth.', isCompleted: true, resourceUrl: 'https://m3.material.io/styles/elevation'),
        PathStep(id: 'step-1-3', order: 3, title: 'Responsive Semantic Shells', isCompleted: true, resourceUrl: 'https://web.dev/learn/design'),
        PathStep(id: 'step-1-4', order: 4, title: 'Micro-interactions in Practice', isCompleted: true, resourceUrl: 'https://uxdesign.cc/micro-interactions'),
        PathStep(id: 'step-1-5', order: 5, title: 'Designing for Cognitive Load', isCompleted: true, resourceUrl: 'https://nngroup.com/articles/cognitive-load'),
        PathStep(id: 'step-1-6', order: 6, title: 'Component Architecture in Figma', isCompleted: false, resourceUrl: 'https://figma.com/best-practices'),
        PathStep(id: 'step-1-7', order: 7, title: 'Accessibility First Design', isCompleted: false, resourceUrl: 'https://a11y.coffee'),
        PathStep(id: 'step-1-8', order: 8, title: 'Design Tokens & Theming', isCompleted: false),
        PathStep(id: 'step-1-9', order: 9, title: 'Motion Design Principles', isCompleted: false),
        PathStep(id: 'step-1-10', order: 10, title: 'Prototyping for Usability Testing', isCompleted: false),
        PathStep(id: 'step-1-11', order: 11, title: 'Final Portfolio Project', isCompleted: false),
      ],
      createdAt: DateTime(2024, 6, 1),
      updatedAt: DateTime(2024, 8, 20),
    ),
    LearningPath(
      id: 'path-2',
      title: 'Data Visualization Basics',
      description: 'Communicating complex data effectively.',
      steps: [
        PathStep(id: 'step-2-1', order: 1, title: 'Principles of Visual Encoding', isCompleted: false, resourceUrl: 'https://flowingdata.com'),
        PathStep(id: 'step-2-2', order: 2, title: 'Choosing the Right Chart Type', isCompleted: false),
        PathStep(id: 'step-2-3', order: 3, title: 'Color Theory for Data', isCompleted: false),
        PathStep(id: 'step-2-4', order: 4, title: 'Interactive Charts with D3.js', isCompleted: false, resourceUrl: 'https://d3js.org/getting-started'),
        PathStep(id: 'step-2-5', order: 5, title: 'Storytelling with Data', isCompleted: false),
        PathStep(id: 'step-2-6', order: 6, title: 'Dashboard Design Patterns', isCompleted: false),
        PathStep(id: 'step-2-7', order: 7, title: 'Mobile Data Visualization', isCompleted: false),
        PathStep(id: 'step-2-8', order: 8, title: 'Final Project: Analytics Dashboard', isCompleted: false),
      ],
      createdAt: DateTime(2024, 8, 1),
      updatedAt: DateTime(2024, 8, 1),
    ),
    LearningPath(
      id: 'path-3',
      title: 'Flutter & Dart Mastery',
      description: 'Building production-grade mobile apps with Flutter.',
      steps: [
        PathStep(id: 'step-3-1', order: 1, title: 'Dart Fundamentals', isCompleted: true, resourceUrl: 'https://dart.dev/guides'),
        PathStep(id: 'step-3-2', order: 2, title: 'Flutter Widget Tree Deep Dive', isCompleted: true),
        PathStep(id: 'step-3-3', order: 3, title: 'State Management with Riverpod', isCompleted: true, resourceUrl: 'https://riverpod.dev'),
        PathStep(id: 'step-3-4', order: 4, title: 'Navigation with go_router', isCompleted: false),
        PathStep(id: 'step-3-5', order: 5, title: 'Animations & Transitions', isCompleted: false),
        PathStep(id: 'step-3-6', order: 6, title: 'Testing Flutter Apps', isCompleted: false),
        PathStep(id: 'step-3-7', order: 7, title: 'Publishing to App Stores', isCompleted: false),
      ],
      createdAt: DateTime(2024, 5, 1),
      updatedAt: DateTime(2024, 8, 15),
    ),
  ];

  @override
  Future<List<LearningPath>> getAll() async => List.unmodifiable(_paths);

  @override
  Future<LearningPath?> getById(String id) async =>
      _paths.where((p) => p.id == id).firstOrNull;

  @override
  Future<LearningPath> add(LearningPath path) async {
    final newPath = path.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _paths.add(newPath);
    return newPath;
  }

  @override
  Future<LearningPath> update(LearningPath path) async {
    final idx = _paths.indexWhere((p) => p.id == path.id);
    if (idx == -1) throw Exception('LearningPath not found: ${path.id}');
    final updated = path.copyWith(updatedAt: DateTime.now());
    _paths[idx] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _paths.removeWhere((p) => p.id == id);
  }

  @override
  Future<LearningPath> toggleStep(String pathId, String stepId) async {
    final pathIdx = _paths.indexWhere((p) => p.id == pathId);
    if (pathIdx == -1) throw Exception('LearningPath not found: $pathId');
    final path = _paths[pathIdx];
    final updatedSteps = path.steps.map((s) {
      if (s.id == stepId) return s.copyWith(isCompleted: !s.isCompleted);
      return s;
    }).toList();
    final updated = path.copyWith(steps: updatedSteps, updatedAt: DateTime.now());
    _paths[pathIdx] = updated;
    return updated;
  }
}
