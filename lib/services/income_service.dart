import 'package:dio/dio.dart';
import '../models/income_model.dart';
import 'api_client.dart';

class IncomeService {
  final ApiClient _apiClient;

  IncomeService() : _apiClient = ApiClient();

  /// Create a new income
  Future<IncomeModel> createIncome({
    required String projectId,
    required String description,
    required int expectedAmount,
    required String currency,
    required String type,
    String? frequency,
    required DateTime startDate,
    DateTime? nextExpectedDate,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? investmentId,
    String? goalId,
    String? reminderId,
    String? source,
    String? invoiceNumber,
    String? notes,
    bool? isActive,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/income',
        data: {
          'projectId': projectId,
          'description': description,
          'expectedAmount': expectedAmount,
          'currency': currency,
          'type': type,
          'frequency': frequency,
          'startDate': startDate.toIso8601String(),
          'nextExpectedDate': nextExpectedDate?.toIso8601String(),
          'categoryId': categoryId,
          'merchantId': merchantId,
          'contactId': contactId,
          'walletId': walletId,
          'investmentId': investmentId,
          'goalId': goalId,
          'reminderId': reminderId,
          'source': source,
          'invoiceNumber': invoiceNumber,
          'notes': notes,
          'isActive': isActive,
        },
      );

      return IncomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all income
  Future<List<IncomeModel>> getAllIncome({
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
        '/income',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((income) => IncomeModel.fromJson(income))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((income) => IncomeModel.fromJson(income))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single income by ID
  Future<IncomeModel> getIncomeById(String id) async {
    try {
      final response = await _apiClient.dio.get('/income/$id');
      return IncomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing income
  Future<IncomeModel> updateIncome({
    required String id,
    String? description,
    int? expectedAmount,
    String? currency,
    String? type,
    String? frequency,
    DateTime? startDate,
    DateTime? nextExpectedDate,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? investmentId,
    String? goalId,
    String? reminderId,
    String? source,
    String? invoiceNumber,
    String? notes,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (description != null) data['description'] = description;
      if (expectedAmount != null) data['expectedAmount'] = expectedAmount;
      if (currency != null) data['currency'] = currency;
      if (type != null) data['type'] = type;
      if (frequency != null) data['frequency'] = frequency;
      if (startDate != null) data['startDate'] = startDate.toIso8601String();
      if (nextExpectedDate != null) {
        data['nextExpectedDate'] = nextExpectedDate.toIso8601String();
      }
      if (categoryId != null) data['categoryId'] = categoryId;
      if (merchantId != null) data['merchantId'] = merchantId;
      if (contactId != null) data['contactId'] = contactId;
      if (walletId != null) data['walletId'] = walletId;
      if (investmentId != null) data['investmentId'] = investmentId;
      if (goalId != null) data['goalId'] = goalId;
      if (reminderId != null) data['reminderId'] = reminderId;
      if (source != null) data['source'] = source;
      if (invoiceNumber != null) data['invoiceNumber'] = invoiceNumber;
      if (notes != null) data['notes'] = notes;
      if (isActive != null) data['isActive'] = isActive;

      final response = await _apiClient.dio.put('/income/$id', data: data);
      return IncomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete an income
  Future<void> deleteIncome(String id) async {
    try {
      await _apiClient.dio.delete('/income/$id');
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
          return data['message'] ?? 'Income not found';
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
