import 'package:dio/dio.dart';
import '../models/budget_model.dart';
import 'api_client.dart';

class BudgetService {
  final ApiClient _apiClient;

  BudgetService() : _apiClient = ApiClient();

  /// Create a new budget
  Future<BudgetModel> createBudget({
    required String name,
    String? description,
    int? underLimitGoal,
    required DateTime startDate,
    required DateTime endDate,
    bool? isActive,
    required String projectId,
    String? categoryId,
    required String currency,
    required int limitAmount,
    int? spentAmount,
    int? overBudgetAllowance,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/budgets',
        data: {
          'name': name,
          'description': description,
          'underLimitGoal': underLimitGoal,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'isActive': isActive,
          'projectId': projectId,
          'categoryId': categoryId,
          'currency': currency,
          'limitAmount': limitAmount,
          'spentAmount': spentAmount,
          'overBudgetAllowance': overBudgetAllowance,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
        },
      );

      return BudgetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all budgets
  Future<List<BudgetModel>> getAllBudgets({
    String? projectId,
    String? categoryId,
    bool? isActive,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (projectId != null) queryParameters['projectId'] = projectId;
      if (categoryId != null) queryParameters['categoryId'] = categoryId;
      if (isActive != null) queryParameters['isActive'] = isActive;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/budgets',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((budget) => BudgetModel.fromJson(budget))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((budget) => BudgetModel.fromJson(budget))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single budget by ID
  Future<BudgetModel> getBudgetById(String id) async {
    try {
      final response = await _apiClient.dio.get('/budgets/$id');
      return BudgetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing budget
  Future<BudgetModel> updateBudget({
    required String id,
    String? name,
    String? description,
    int? underLimitGoal,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? projectId,
    String? categoryId,
    String? currency,
    int? limitAmount,
    int? spentAmount,
    int? overBudgetAllowance,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (underLimitGoal != null) data['underLimitGoal'] = underLimitGoal;
      if (startDate != null) data['startDate'] = startDate.toIso8601String();
      if (endDate != null) data['endDate'] = endDate.toIso8601String();
      if (isActive != null) data['isActive'] = isActive;
      if (projectId != null) data['projectId'] = projectId;
      if (categoryId != null) data['categoryId'] = categoryId;
      if (currency != null) data['currency'] = currency;
      if (limitAmount != null) data['limitAmount'] = limitAmount;
      if (spentAmount != null) data['spentAmount'] = spentAmount;
      if (overBudgetAllowance != null) {
        data['overBudgetAllowance'] = overBudgetAllowance;
      }
      if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
      if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
      if (iconType != null) data['iconType'] = iconType;
      if (color != null) data['color'] = color;

      final response = await _apiClient.dio.put('/budgets/$id', data: data);
      return BudgetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a budget
  Future<void> deleteBudget(String id) async {
    try {
      await _apiClient.dio.delete('/budgets/$id');
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
          return data['message'] ?? 'Budget not found';
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
