import 'package:billkeep/database/database.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:billkeep/models/project_model.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/utils/connectivity_helper.dart';
import 'base_api_service.dart';

class ProjectService extends BaseApiService {
  final ProjectRepository _repository;

  ProjectService(this._repository) {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for projects collection
  void _setupRealtimeSync() {
    subscribeToCollection('projects', _handleProjectUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleProjectUpdate(RecordSubscriptionEvent event) {
    print('🔄 Project ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncProjectFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            _repository.deleteProject(event.record!.id);
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling project update: $e');
    }
  }

  /// Sync project from backend to local DB
  Future<void> _syncProjectFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      final tempId = record.getStringValue('tempId');

      print('📥 Syncing project: tempId=$tempId → canonicalId=$canonicalId');
      // TODO: handle realtime event
      // Find local project by tempId and update with canonical ID
      // Similar to WalletService implementation
    } catch (e) {
      print('⚠️ Error syncing project: $e');
    }
  }
  /// Create a new project
  ///
  /// Local-first approach:
  /// 1. Create in local DB first with temp ID
  /// 2. Check connectivity and send to backend if online
  /// 3. Realtime sync will update with canonical ID when backend confirms
  // Future<Project> createProject({
  //   required String name,
  //   required String userId,
  //   String? defaultWallet,
  //   String? description,
  //   String? emoji = '📂',
  //   String? imageUrl,
  //   String? localImagePath,
  //   String? color,
  //   String? iconType = 'emoji',
  //   int? iconCodePoint,
  //   bool? isArchived,
  //   String? status,
  // }) async {
  //   // 1. Create in local database first (optimistic)
  //   final tempId = await _repository.createProject(
  //     name: name,
  //     userId: userId,
  //     description: description,
  //     defaultWallet: defaultWallet,
  //     iconType: iconType!,
  //     emoji: emoji,
  //     imageUrl: imageUrl,
  //     localImagePath: localImagePath,
  //     iconCodePoint: iconCodePoint,
  //     color: color,
  //     isArchived: false,
  //   );

  //   // 2. Check connectivity and send to backend if online
  //   final isOnline = await ConnectivityHelper.hasInternetConnection();

  //   if (isOnline) {
  //     try {
  //       final apiProject = await executeRequest<Project>(
  //         request: () => dio.post(
  //           '/projects/records',
  //           data: {
  //             'name': name,
  //             'description': description,
  //             'defaultWallet': defaultWallet,
  //             'user': userId,
  //             'status': status ?? 'ACTIVE',
  //           },
  //         ),
  //         parser: (data) => Project.fromJson(data),
  //       );

  //       // Note: Realtime sync service will handle updating local DB with canonical ID
  //       // But we return the API response immediately
  //       return apiProject;
  //     } catch (e) {
  //       // If API fails, we still have local copy
  //       print('API call failed, project saved locally: $e');

  //       // Get the local project to return
  //       final localProjects = await _repository.getUnsyncedProjects();
  //       final localProject = localProjects.firstWhere(
  //         (p) => p.id == tempId,
  //         orElse: () => throw Exception('Failed to retrieve local project'),
  //       );

  //       return Project(
  //         id: localProject.id,
  //         name: localProject.name,
  //         description: localProject.description,
  //         status: status ?? 'ACTIVE',
  //         createdAt: localProject.createdAt,
  //         updatedAt: localProject.updatedAt,
  //       );
  //     }
  //   } else {
  //     // Offline: return local project
  //     final localProjects = await _repository.getUnsyncedProjects();
  //     final localProject = localProjects.firstWhere(
  //       (p) => p.id == tempId,
  //       orElse: () => throw Exception('Failed to retrieve local project'),
  //     );

  //     return Project(
  //       id: localProject.id,
  //       name: localProject.name,
  //       description: localProject.description,
  //       status: status ?? 'ACTIVE',
  //       createdAt: localProject.createdAt,
  //       updatedAt: localProject.updatedAt,
  //     );
  //   }
  // }

  /// Get all projects
  Future<List<Project>> getAllProjects({
    int? page,
    int? limit,
    String? status,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (status != null) queryParameters['status'] = status;

    return executeListRequest<Project>(
      request: () => dio.get(
        '/projects',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => Project.fromJson(json),
    );
  }

  /// Get a single project by ID
  Future<Project> getProjectById(String id) async {
    return executeRequest<Project>(
      request: () => dio.get('/projects/$id'),
      parser: (data) => Project.fromJson(data),
    );
  }

  /// Update an existing project
  Future<Project> updateProject({
    required String id,
    String? name,
    String? description,
    String? status,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (status != null) data['status'] = status;

    return executeRequest<Project>(
      request: () => dio.put(
        '/projects/$id',
        data: data,
      ),
      parser: (data) => Project.fromJson(data),
    );
  }

  /// Partially update a project (PATCH)
  Future<Project> patchProject({
    required String id,
    Map<String, dynamic>? updates,
  }) async {
    return executeRequest<Project>(
      request: () => dio.patch(
        '/projects/$id',
        data: updates,
      ),
      parser: (data) => Project.fromJson(data),
    );
  }

  /// Delete a project
  Future<void> deleteProject(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/projects/$id'),
    );
  }
}
