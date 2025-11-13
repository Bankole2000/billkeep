import '../models/project_model.dart';
import 'base_api_service.dart';

class ProjectService extends BaseApiService {
  /// Create a new project
  Future<Project> createProject({
    required String name,
    String? description,
    String? status,
  }) async {
    return executeRequest<Project>(
      request: () => dio.post(
        '/projects',
        data: {
          'name': name,
          'description': description,
          'status': status,
        },
      ),
      parser: (data) => Project.fromJson(data),
    );
  }

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
