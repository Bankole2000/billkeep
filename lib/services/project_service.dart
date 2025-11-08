import 'package:dio/dio.dart';
import '../models/project_model.dart';
import 'api_client.dart';

class ProjectService {
  final ApiClient _apiClient;

  ProjectService() : _apiClient = ApiClient();

  /// Create a new project
  Future<Project> createProject({
    required String name,
    String? description,
    String? status,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/projects',
        data: {
          'name': name,
          'description': description,
          'status': status,
        },
      );

      return Project.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all projects
  Future<List<Project>> getAllProjects({
    int? page,
    int? limit,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (status != null) queryParameters['status'] = status;

      final response = await _apiClient.dio.get(
        '/projects',
        queryParameters: queryParameters,
      );

      // Handle both array response and paginated response
      if (response.data is List) {
        return (response.data as List)
            .map((project) => Project.fromJson(project))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((project) => Project.fromJson(project))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single project by ID
  Future<Project> getProjectById(String id) async {
    try {
      final response = await _apiClient.dio.get('/projects/$id');
      return Project.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing project
  Future<Project> updateProject({
    required String id,
    String? name,
    String? description,
    String? status,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (status != null) data['status'] = status;

      final response = await _apiClient.dio.put(
        '/projects/$id',
        data: data,
      );

      return Project.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Partially update a project (PATCH)
  Future<Project> patchProject({
    required String id,
    Map<String, dynamic>? updates,
  }) async {
    try {
      final response = await _apiClient.dio.patch(
        '/projects/$id',
        data: updates,
      );

      return Project.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a project
  Future<void> deleteProject(String id) async {
    try {
      await _apiClient.dio.delete('/projects/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Bad request';
        case 401:
          return data['message'] ?? 'Unauthorized';
        case 403:
          return data['message'] ?? 'Forbidden';
        case 404:
          return data['message'] ?? 'Project not found';
        case 409:
          return data['message'] ?? 'Conflict - project already exists';
        case 500:
          return 'Internal server error';
        default:
          return data['message'] ?? 'An error occurred';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    } else {
      return error.message ?? 'An unexpected error occurred';
    }
  }
}
