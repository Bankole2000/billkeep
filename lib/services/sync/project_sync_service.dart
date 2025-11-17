import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../../database/database.dart';
import '../../models/project_model.dart' hide Project;
import '../../providers/project_provider.dart';
import '../../services/api_client.dart';
import '../../utils/exceptions.dart';
import '../../utils/id_generator.dart';
import 'base_sync_service.dart';

/// Synchronization service for Projects
///
/// Handles bidirectional sync between local Drift database and remote API
/// Makes DIRECT API calls (not through ProjectService) to avoid double-writing
class ProjectSyncService extends BaseSyncService {
  final AppDatabase _database;
  final ProjectRepository _repository;
  final Dio _dio;

  ProjectSyncService({
    required AppDatabase database,
    required ProjectRepository repository,
    Dio? dio,
  })  : _database = database,
        _repository = repository,
        _dio = dio ?? ApiClient().dio;

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

    // Send to API directly (not through ProjectService to avoid double-writing)
    try {
      final response = await _dio.post(
        '/projects/records',
        data: {
          'name': localProject.name,
          'description': localProject.description,
          'status': 'ACTIVE',
          // Add other fields as needed
        },
      );

      final apiProject = Project.fromJson(response.data);

      // Update local database with canonical ID
      await _updateProjectWithCanonicalId(
        tempId: tempId,
        canonicalId: apiProject.id,
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw SyncException(
        'Failed to sync project: $message',
        'Unable to sync project. Will retry later.',
      );
    } catch (e) {
      throw SyncException(
        'Failed to sync project: ${e.toString()}',
        'Unable to sync project. Will retry later.',
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
      // Fetch all projects from API directly
      final response = await _dio.get('/projects/records');

      List<Project> apiProjects;
      if (response.data is List) {
        apiProjects = (response.data as List)
            .map((item) => Project.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map && response.data['items'] != null) {
        apiProjects = (response.data['items'] as List)
            .map((item) => Project.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        apiProjects = [];
      }

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
                  iconType: const Value('MaterialIcons'),
                  isArchived: const Value(false),
                  isSynced: const Value(true),
                ),
              );
        }
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw SyncException(
        'Failed to pull projects from server: $message',
        'Unable to fetch projects from server.',
      );
    } catch (e) {
      throw SyncException(
        'Failed to pull projects from server: ${e.toString()}',
        'Unable to fetch projects from server.',
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
        await _dio.delete('/projects/records/$projectId');
      } on DioException catch (e) {
        final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
        throw SyncException(
          'Failed to delete project from server: $message',
          'Unable to delete project from server.',
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
        await _dio.patch(
          '/projects/records/$projectId',
          data: {
            'name': name,
            'description': description,
          },
        );

        // Mark as synced
        await (_database.update(_database.projects)
              ..where((p) => p.id.equals(projectId)))
            .write(const ProjectsCompanion(isSynced: Value(true)));
      } on DioException catch (e) {
        final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
        // Failed to sync, but local update succeeded
        // Will be synced later
        throw SyncException(
          'Updated locally but failed to sync: $message',
          'Changes saved locally and will sync when connection is available',
        );
      }
    }
  }
}
