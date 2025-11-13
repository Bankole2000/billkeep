import '../models/investment_model.dart';
import 'base_api_service.dart';

class InvestmentService extends BaseApiService {
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
    return executeRequest<InvestmentModel>(
      request: () => dio.post(
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
      ),
      parser: (data) => InvestmentModel.fromJson(data),
    );
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
    final queryParameters = <String, dynamic>{};

    if (investmentTypeId != null) {
      queryParameters['investmentTypeId'] = investmentTypeId;
    }
    if (currencyCode != null) queryParameters['currencyCode'] = currencyCode;
    if (contactId != null) queryParameters['contactId'] = contactId;
    if (merchantId != null) queryParameters['merchantId'] = merchantId;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<InvestmentModel>(
      request: () => dio.get(
        '/investments',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => InvestmentModel.fromJson(json),
    );
  }

  /// Get a single investment by ID
  Future<InvestmentModel> getInvestmentById(String id) async {
    return executeRequest<InvestmentModel>(
      request: () => dio.get('/investments/$id'),
      parser: (data) => InvestmentModel.fromJson(data),
    );
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

    return executeRequest<InvestmentModel>(
      request: () => dio.put('/investments/$id', data: data),
      parser: (data) => InvestmentModel.fromJson(data),
    );
  }

  /// Delete an investment
  Future<void> deleteInvestment(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/investments/$id'),
    );
  }
}
