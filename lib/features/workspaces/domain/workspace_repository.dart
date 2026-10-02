import 'package:my_logs/features/workspaces/domain/models/workspace_item.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceItem>> getAll();
  Future<WorkspaceItem?> getById(String id);
  Future<WorkspaceItem> add(WorkspaceItem workspace);
  Future<WorkspaceItem> update(WorkspaceItem workspace);
  Future<void> delete(String id);
}
