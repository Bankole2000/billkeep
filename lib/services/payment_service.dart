import '../models/payment_model.dart';
import 'base_api_service.dart';

class PaymentService extends BaseApiService {
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
    return executeRequest<PaymentModel>(
      request: () => dio.post(
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
      ),
      parser: (data) => PaymentModel.fromJson(data),
    );
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

    return executeListRequest<PaymentModel>(
      request: () => dio.get(
        '/payments',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => PaymentModel.fromJson(json),
    );
  }

  /// Get a single payment by ID
  Future<PaymentModel> getPaymentById(String id) async {
    return executeRequest<PaymentModel>(
      request: () => dio.get('/payments/$id'),
      parser: (data) => PaymentModel.fromJson(data),
    );
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

    return executeRequest<PaymentModel>(
      request: () => dio.put('/payments/$id', data: data),
      parser: (data) => PaymentModel.fromJson(data),
    );
  }

  /// Delete a payment
  Future<void> deletePayment(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/payments/$id'),
    );
  }
}
