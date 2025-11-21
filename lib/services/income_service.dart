import 'package:pocketbase/pocketbase.dart';
import '../models/income_model.dart';
import 'base_api_service.dart';

class IncomeService extends BaseApiService {
  IncomeService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for income collection
  void _setupRealtimeSync() {
    subscribeToCollection('income', _handleIncomeUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleIncomeUpdate(RecordSubscriptionEvent event) {
    print('🔄 Income ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncIncomeFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle income deletion in local DB if needed
            print('🗑️ Income deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling income update: $e');
    }
  }

  /// Sync income from backend to local DB
  Future<void> _syncIncomeFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing income: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing income: $e');
    }
  }

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
    return executeRequest<IncomeModel>(
      request: () => dio.post(
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
      ),
      parser: (data) => IncomeModel.fromJson(data),
    );
  }

  /// Get all income
  Future<List<IncomeModel>> getAllIncome({
    String? projectId,
    String? type,
    bool? isActive,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (projectId != null) queryParameters['projectId'] = projectId;
    if (type != null) queryParameters['type'] = type;
    if (isActive != null) queryParameters['isActive'] = isActive;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<IncomeModel>(
      request: () => dio.get(
        '/income',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => IncomeModel.fromJson(json),
    );
  }

  /// Get a single income by ID
  Future<IncomeModel> getIncomeById(String id) async {
    return executeRequest<IncomeModel>(
      request: () => dio.get('/income/$id'),
      parser: (data) => IncomeModel.fromJson(data),
    );
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

    return executeRequest<IncomeModel>(
      request: () => dio.put('/income/$id', data: data),
      parser: (data) => IncomeModel.fromJson(data),
    );
  }

  /// Delete an income
  Future<void> deleteIncome(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/income/$id'),
    );
  }
}
