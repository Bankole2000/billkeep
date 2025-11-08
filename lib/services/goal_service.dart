import 'package:dio/dio.dart';
import '../models/goal_model.dart';
import 'api_client.dart';

class GoalService {
  final ApiClient _apiClient;

  GoalService() : _apiClient = ApiClient();

  /// Create a new goal
  Future<GoalModel> createGoal({
    required String name,
    required String type,
    required int targetAmount,
    String? contactId,
    String? categoryId,
    int? currentAmount,
    DateTime? targetDate,
    bool? isCompleted,
    String? description,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/goals',
        data: {
          'name': name,
          'type': type,
          'targetAmount': targetAmount,
          'contactId': contactId,
          'categoryId': categoryId,
          'currentAmount': currentAmount,
          'targetDate': targetDate?.toIso8601String(),
          'isCompleted': isCompleted,
          'description': description,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
        },
      );

      return GoalModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all goals
  Future<List<GoalModel>> getAllGoals({
    String? type,
    bool? isCompleted,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (type != null) queryParameters['type'] = type;
      if (isCompleted != null) queryParameters['isCompleted'] = isCompleted;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/goals',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((goal) => GoalModel.fromJson(goal))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((goal) => GoalModel.fromJson(goal))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single goal by ID
  Future<GoalModel> getGoalById(String id) async {
    try {
      final response = await _apiClient.dio.get('/goals/$id');
      return GoalModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing goal
  Future<GoalModel> updateGoal({
    required String id,
    String? name,
    String? type,
    int? targetAmount,
    String? contactId,
    String? categoryId,
    int? currentAmount,
    DateTime? targetDate,
    bool? isCompleted,
    String? description,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (type != null) data['type'] = type;
      if (targetAmount != null) data['targetAmount'] = targetAmount;
      if (contactId != null) data['contactId'] = contactId;
      if (categoryId != null) data['categoryId'] = categoryId;
      if (currentAmount != null) data['currentAmount'] = currentAmount;
      if (targetDate != null) {
        data['targetDate'] = targetDate.toIso8601String();
      }
      if (isCompleted != null) data['isCompleted'] = isCompleted;
      if (description != null) data['description'] = description;
      if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
      if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
      if (iconType != null) data['iconType'] = iconType;
      if (color != null) data['color'] = color;

      final response = await _apiClient.dio.put('/goals/$id', data: data);
      return GoalModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a goal
  Future<void> deleteGoal(String id) async {
    try {
      await _apiClient.dio.delete('/goals/$id');
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
          return data['message'] ?? 'Goal not found';
        case 409:
          return data['message'] ?? 'Conflict';
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
