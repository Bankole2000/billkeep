import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/project_model.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:drift/drift.dart';

class ProjectRepository {
  final AppDatabase _database;

  ProjectRepository(this._database);

  /// Create a new project using ProjectModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final project = ProjectModel(
  ///   name: 'My Project',
  ///   userId: userId,
  ///   description: 'Project description',
  ///   iconEmoji: '📁',
  ///   color: '#0000FF',
  /// );
  /// final id = await repository.createProject(project);
  /// ```
  Future<String> createProject(ProjectModel newProject) async {
    final tempId = IdGenerator.tempProject();

    try {
      await _database.createProject(newProject.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error creating project: $e');
      rethrow;
    }

    return tempId;
  }

  // Called after server responds with canonical ID
  Future<void> updateProjectWithCanonicalId({
    required String tempId,
    required String canonicalId,
  }) async {
    // Map the IDs
    await _database.mapId(
      tempId: tempId,
      canonicalId: canonicalId,
      resourceType: 'project',
    );

    // Update project with canonical ID
    await (_database.update(
      _database.projects,
    )..where((t) => t.id.equals(tempId))).write(
      ProjectsCompanion(id: Value(canonicalId), isSynced: const Value(true)),
    );
  }

  Stream<List<Project>> watchAllProjects() {
    return _database.select(_database.projects).watch();
  }

  // Get unsynced projects for sending to server
  Future<List<Project>> getUnsyncedProjects() {
    return (_database.select(
      _database.projects,
    )..where((t) => t.isSynced.equals(false))).get();
  }

  /// Update project using ProjectModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentProject.copyWith(name: 'New Name', description: 'Updated');
  /// await repository.updateProject(updated);
  /// ```
  Future<String> updateProject(ProjectModel updatedProject) async {
    if (updatedProject.id == null) {
      throw ArgumentError('Cannot update project without an ID');
    }

    try {
      await (_database.update(
        _database.projects,
      )..where((p) => p.id.equals(updatedProject.id!))).write(
        updatedProject.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
    return updatedProject.id!;
  }

  Future<void> deleteProject(String projectId) async {
    await (_database.delete(
      _database.projects,
    )..where((p) => p.id.equals(projectId))).go();
  }

  Future<void> toggleArchiveProject(String projectId, bool isArchived) async {
    await (_database.update(_database.projects)
          ..where((p) => p.id.equals(projectId)))
        .write(ProjectsCompanion(isArchived: Value(isArchived)));
  }
}
