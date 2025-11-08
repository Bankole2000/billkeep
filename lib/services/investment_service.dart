import 'package:dio/dio.dart';
import '../models/investment_model.dart';
import 'api_client.dart';

class InvestmentService {
  final ApiClient _apiClient;

  InvestmentService() : _apiClient = ApiClient();

  /// Create a new investment
  Future<InvestmentModel> createInvestment({
    required String name,
    required String investmentTypeId,
    required DateTime investmentDate,
    DateTime? maturityDate,
    DateTime? closedDate,
    required String currencyCode,
    required int investedAmount,
    int? currentValue,
    required String returnCalculationType,
    int? interestRate,
    int? fixedReturnAmount,
    String? returnFrequency,
    String? contactId,
    String? merchantId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/investments',
        data: {
          'name': name,
          'investmentTypeId': investmentTypeId,
          'investmentDate': investmentDate.toIso8601String(),
          'maturityDate': maturityDate?.toIso8601String(),
          'closedDate': closedDate?.toIso8601String(),
          'currencyCode': currencyCode,
          'investedAmount': investedAmount,
          'currentValue': currentValue,
          'returnCalculationType': returnCalculationType,
          'interestRate': interestRate,
          'fixedReturnAmount': fixedReturnAmount,
          'returnFrequency': returnFrequency,
          'contactId': contactId,
          'merchantId': merchantId,
        },
      );

      return InvestmentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all investments
  Future<List<InvestmentModel>> getAllInvestments({
    String? investmentTypeId,
    String? currencyCode,
    String? contactId,
    String? merchantId,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (investmentTypeId != null) {
        queryParameters['investmentTypeId'] = investmentTypeId;
      }
      if (currencyCode != null) queryParameters['currencyCode'] = currencyCode;
      if (contactId != null) queryParameters['contactId'] = contactId;
      if (merchantId != null) queryParameters['merchantId'] = merchantId;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/investments',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((investment) => InvestmentModel.fromJson(investment))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((investment) => InvestmentModel.fromJson(investment))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single investment by ID
  Future<InvestmentModel> getInvestmentById(String id) async {
    try {
      final response = await _apiClient.dio.get('/investments/$id');
      return InvestmentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing investment
  Future<InvestmentModel> updateInvestment({
    required String id,
    String? name,
    String? investmentTypeId,
    DateTime? investmentDate,
    DateTime? maturityDate,
    DateTime? closedDate,
    String? currencyCode,
    int? investedAmount,
    int? currentValue,
    String? returnCalculationType,
    int? interestRate,
    int? fixedReturnAmount,
    String? returnFrequency,
    String? contactId,
    String? merchantId,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (investmentTypeId != null) {
        data['investmentTypeId'] = investmentTypeId;
      }
      if (investmentDate != null) {
        data['investmentDate'] = investmentDate.toIso8601String();
      }
      if (maturityDate != null) {
        data['maturityDate'] = maturityDate.toIso8601String();
      }
      if (closedDate != null) {
        data['closedDate'] = closedDate.toIso8601String();
      }
      if (currencyCode != null) data['currencyCode'] = currencyCode;
      if (investedAmount != null) data['investedAmount'] = investedAmount;
      if (currentValue != null) data['currentValue'] = currentValue;
      if (returnCalculationType != null) {
        data['returnCalculationType'] = returnCalculationType;
      }
      if (interestRate != null) data['interestRate'] = interestRate;
      if (fixedReturnAmount != null) {
        data['fixedReturnAmount'] = fixedReturnAmount;
      }
      if (returnFrequency != null) data['returnFrequency'] = returnFrequency;
      if (contactId != null) data['contactId'] = contactId;
      if (merchantId != null) data['merchantId'] = merchantId;

      final response = await _apiClient.dio.put('/investments/$id', data: data);
      return InvestmentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete an investment
  Future<void> deleteInvestment(String id) async {
    try {
      await _apiClient.dio.delete('/investments/$id');
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
          return data['message'] ?? 'Investment not found';
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
