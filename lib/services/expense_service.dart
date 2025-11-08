import 'package:dio/dio.dart';
import '../models/expense_model.dart';
import 'api_client.dart';

class ExpenseService {
  final ApiClient _apiClient;

  ExpenseService() : _apiClient = ApiClient();

  /// Create a new expense
  Future<ExpenseModel> createExpense({
    required String projectId,
    required String name,
    required int expectedAmount,
    required String currency,
    required String type,
    String? frequency,
    required DateTime startDate,
    DateTime? nextRenewalDate,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? investmentId,
    String? goalId,
    String? reminderId,
    String? source,
    String? notes,
    bool? isActive,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/expenses',
        data: {
          'projectId': projectId,
          'name': name,
          'expectedAmount': expectedAmount,
          'currency': currency,
          'type': type,
          'frequency': frequency,
          'startDate': startDate.toIso8601String(),
          'nextRenewalDate': nextRenewalDate?.toIso8601String(),
          'categoryId': categoryId,
          'merchantId': merchantId,
          'contactId': contactId,
          'walletId': walletId,
          'investmentId': investmentId,
          'goalId': goalId,
          'reminderId': reminderId,
          'source': source,
          'notes': notes,
          'isActive': isActive,
        },
      );

      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all expenses
  Future<List<ExpenseModel>> getAllExpenses({
    String? projectId,
    String? type,
    bool? isActive,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (projectId != null) queryParameters['projectId'] = projectId;
      if (type != null) queryParameters['type'] = type;
      if (isActive != null) queryParameters['isActive'] = isActive;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/expenses',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((expense) => ExpenseModel.fromJson(expense))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((expense) => ExpenseModel.fromJson(expense))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single expense by ID
  Future<ExpenseModel> getExpenseById(String id) async {
    try {
      final response = await _apiClient.dio.get('/expenses/$id');
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing expense
  Future<ExpenseModel> updateExpense({
    required String id,
    String? name,
    int? expectedAmount,
    String? currency,
    String? type,
    String? frequency,
    DateTime? startDate,
    DateTime? nextRenewalDate,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? investmentId,
    String? goalId,
    String? reminderId,
    String? source,
    String? notes,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (expectedAmount != null) data['expectedAmount'] = expectedAmount;
      if (currency != null) data['currency'] = currency;
      if (type != null) data['type'] = type;
      if (frequency != null) data['frequency'] = frequency;
      if (startDate != null) data['startDate'] = startDate.toIso8601String();
      if (nextRenewalDate != null) {
        data['nextRenewalDate'] = nextRenewalDate.toIso8601String();
      }
      if (categoryId != null) data['categoryId'] = categoryId;
      if (merchantId != null) data['merchantId'] = merchantId;
      if (contactId != null) data['contactId'] = contactId;
      if (walletId != null) data['walletId'] = walletId;
      if (investmentId != null) data['investmentId'] = investmentId;
      if (goalId != null) data['goalId'] = goalId;
      if (reminderId != null) data['reminderId'] = reminderId;
      if (source != null) data['source'] = source;
      if (notes != null) data['notes'] = notes;
      if (isActive != null) data['isActive'] = isActive;

      final response = await _apiClient.dio.put('/expenses/$id', data: data);
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    try {
      await _apiClient.dio.delete('/expenses/$id');
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
          return data['message'] ?? 'Expense not found';
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
