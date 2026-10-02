/// Interface implemented by any domain entity scoped to a specific workspace.
/// Enables type-safe generic filtering across features and eliminates redundant provider boilerplate (ISP / DRY).
abstract interface class WorkspaceScoped {
  String get workspaceId;
}
