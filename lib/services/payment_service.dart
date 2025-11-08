import 'package:dio/dio.dart';
import '../models/payment_model.dart';
import 'api_client.dart';

class PaymentService {
  final ApiClient _apiClient;

  PaymentService() : _apiClient = ApiClient();

  /// Create a new payment
  Future<PaymentModel> createPayment({
    required String paymentType,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? expenseId,
    String? incomeId,
    String? investmentId,
    String? debtId,
    required int actualAmount,
    required String currency,
    required DateTime paymentDate,
    String? source,
    bool? verified,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/payments',
        data: {
          'paymentType': paymentType,
          'categoryId': categoryId,
          'merchantId': merchantId,
          'contactId': contactId,
          'walletId': walletId,
          'expenseId': expenseId,
          'incomeId': incomeId,
          'investmentId': investmentId,
          'debtId': debtId,
          'actualAmount': actualAmount,
          'currency': currency,
          'paymentDate': paymentDate.toIso8601String(),
          'source': source,
          'verified': verified,
          'notes': notes,
        },
      );

      return PaymentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all payments
  Future<List<PaymentModel>> getAllPayments({
    String? paymentType,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? expenseId,
    String? incomeId,
    bool? verified,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (paymentType != null) queryParameters['paymentType'] = paymentType;
      if (categoryId != null) queryParameters['categoryId'] = categoryId;
      if (merchantId != null) queryParameters['merchantId'] = merchantId;
      if (contactId != null) queryParameters['contactId'] = contactId;
      if (walletId != null) queryParameters['walletId'] = walletId;
      if (expenseId != null) queryParameters['expenseId'] = expenseId;
      if (incomeId != null) queryParameters['incomeId'] = incomeId;
      if (verified != null) queryParameters['verified'] = verified;
      if (startDate != null) {
        queryParameters['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate.toIso8601String();
      }
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/payments',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((payment) => PaymentModel.fromJson(payment))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((payment) => PaymentModel.fromJson(payment))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single payment by ID
  Future<PaymentModel> getPaymentById(String id) async {
    try {
      final response = await _apiClient.dio.get('/payments/$id');
      return PaymentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing payment
  Future<PaymentModel> updatePayment({
    required String id,
    String? paymentType,
    String? categoryId,
    String? merchantId,
    String? contactId,
    String? walletId,
    String? expenseId,
    String? incomeId,
    String? investmentId,
    String? debtId,
    int? actualAmount,
    String? currency,
    DateTime? paymentDate,
    String? source,
    bool? verified,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (paymentType != null) data['paymentType'] = paymentType;
      if (categoryId != null) data['categoryId'] = categoryId;
      if (merchantId != null) data['merchantId'] = merchantId;
      if (contactId != null) data['contactId'] = contactId;
      if (walletId != null) data['walletId'] = walletId;
      if (expenseId != null) data['expenseId'] = expenseId;
      if (incomeId != null) data['incomeId'] = incomeId;
      if (investmentId != null) data['investmentId'] = investmentId;
      if (debtId != null) data['debtId'] = debtId;
      if (actualAmount != null) data['actualAmount'] = actualAmount;
      if (currency != null) data['currency'] = currency;
      if (paymentDate != null) {
        data['paymentDate'] = paymentDate.toIso8601String();
      }
      if (source != null) data['source'] = source;
      if (verified != null) data['verified'] = verified;
      if (notes != null) data['notes'] = notes;

      final response = await _apiClient.dio.put('/payments/$id', data: data);
      return PaymentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a payment
  Future<void> deletePayment(String id) async {
    try {
      await _apiClient.dio.delete('/payments/$id');
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
          return data['message'] ?? 'Payment not found';
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
