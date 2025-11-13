import 'package:drift/drift.dart';
import '../../database/database.dart';
import '../../utils/exceptions.dart';
import '../../utils/id_generator.dart';
import '../project_service.dart';
import 'base_sync_service.dart';

/// Synchronization service for Projects
///
/// Handles bidirectional sync between local Drift database and remote API
class ProjectSyncService extends BaseSyncService {
  final AppDatabase _database;
  final ProjectService _apiService;

  ProjectSyncService({
    required AppDatabase database,
    ProjectService? apiService,
  }) : _database = database,
       _apiService = apiService ?? ProjectService();

  @override
  Future<void> syncEntity(String tempId) async {
    // Check if already synced
    if (!IdGenerator.isTemporaryId(tempId)) {
      return; // Already has canonical ID
    }

    // Get the local project
    final localProject = await (_database.select(
      _database.projects,
    )..where((p) => p.id.equals(tempId))).getSingleOrNull();

    if (localProject == null) {
      throw NotFoundException(
        'Project with temp ID $tempId not found',
        'The project you are trying to sync does not exist',
      );
    }

    // Check if it's already synced
    if (localProject.isSynced) {
      return;
    }

    // Send to API
    try {
      final apiProject = await _apiService.createProject(
        name: localProject.name,
        description: localProject.description,
      );

      // Update local database with canonical ID
      await _updateProjectWithCanonicalId(
        tempId: tempId,
        canonicalId: apiProject.id,
      );
    } on AppException catch (e) {
      throw SyncException(
        'Failed to sync project: ${e.message}',
        e.getUserMessage(),
      );
    }
  }

  @override
  Future<List<String>> getUnsyncedEntityIds() async {
    final unsyncedProjects = await (_database.select(
      _database.projects,
    )..where((p) => p.isSynced.equals(false))).get();

    return unsyncedProjects.map((p) => p.id).toList();
  }

  @override
  Future<void> pullFromServer() async {
    try {
      // Fetch all projects from API
      final apiProjects = await _apiService.getAllProjects();

      // For each API project, update or insert in local database
      for (final apiProject in apiProjects) {
        final existingProject = await (_database.select(
          _database.projects,
        )..where((p) => p.id.equals(apiProject.id))).getSingleOrNull();

        if (existingProject != null) {
          // Update existing
          await (_database.update(
            _database.projects,
          )..where((p) => p.id.equals(apiProject.id))).write(
            ProjectsCompanion(
              name: Value(apiProject.name),
              description: Value(apiProject.description),
              // status: Value(apiProject.status),
              isSynced: const Value(true),
            ),
          );
        } else {
          // Insert new
          await _database
              .into(_database.projects)
              .insert(
                ProjectsCompanion(
                  id: Value(apiProject.id),
                  name: Value(apiProject.name),
                  description: Value(apiProject.description),
                  isSynced: const Value(true),
                ),
              );
        }
      }
    } on AppException catch (e) {
      throw SyncException(
        'Failed to pull projects from server: ${e.message}',
        e.getUserMessage(),
      );
    }
  }

  /// Perform bidirectional sync
  ///
  /// 1. Push unsynced local changes to server
  /// 2. Pull latest data from server
  Future<SyncResult> performFullSync() async {
    if (!await isOnline()) {
      return SyncResult.failure('No internet connection');
    }

    try {
      // First push local changes
      final pushResult = await syncAll();

      // Then pull from server
      await pullFromServer();

      return pushResult;
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  /// Update a project with its canonical ID after successful sync
  Future<void> _updateProjectWithCanonicalId({
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
    )..where((p) => p.id.equals(tempId))).write(
      ProjectsCompanion(id: Value(canonicalId), isSynced: const Value(true)),
    );
  }

  /// Delete a project both locally and on server
  Future<void> deleteProject(String projectId) async {
    // Delete from server if it's a canonical ID
    if (!IdGenerator.isTemporaryId(projectId) && await isOnline()) {
      try {
        await _apiService.deleteProject(projectId);
      } on AppException catch (e) {
        throw SyncException(
          'Failed to delete project from server: ${e.message}',
          e.getUserMessage(),
        );
      }
    }

    // Delete from local database
    await (_database.delete(
      _database.projects,
    )..where((p) => p.id.equals(projectId))).go();
  }

  /// Update a project both locally and on server
  Future<void> updateProject({
    required String projectId,
    required String name,
    String? description,
  }) async {
    // Update locally first (offline-first approach)
    await (_database.update(
      _database.projects,
    )..where((p) => p.id.equals(projectId))).write(
      ProjectsCompanion(
        name: Value(name),
        description: Value(description),
        isSynced: const Value(false), // Mark as needing sync
      ),
    );

    // If online and has canonical ID, sync immediately
    if (!IdGenerator.isTemporaryId(projectId) && await isOnline()) {
      try {
        await _apiService.updateProject(
          id: projectId,
          name: name,
          description: description,
        );

        // Mark as synced
        await (_database.update(_database.projects)
              ..where((p) => p.id.equals(projectId)))
            .write(const ProjectsCompanion(isSynced: Value(true)));
      } on AppException catch (e) {
        // Failed to sync, but local update succeeded
        // Will be synced later
        throw SyncException(
          'Updated locally but failed to sync: ${e.message}',
          'Changes saved locally and will sync when connection is available',
        );
      }
    }
  }
}
