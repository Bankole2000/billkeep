import 'package:pocketbase/pocketbase.dart';
import '../models/expense_model.dart';
import 'base_api_service.dart';

class ExpenseService extends BaseApiService {
  ExpenseService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for expenses collection
  void _setupRealtimeSync() {
    subscribeToCollection('expenses', _handleExpenseUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleExpenseUpdate(RecordSubscriptionEvent event) {
    print('🔄 Expense ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncExpenseFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle expense deletion in local DB if needed
            print('🗑️ Expense deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling expense update: $e');
    }
  }

  /// Sync expense from backend to local DB
  Future<void> _syncExpenseFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing expense: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing expense: $e');
    }
  }

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
    return executeRequest<ExpenseModel>(
      request: () => dio.post(
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
      ),
      parser: (data) => ExpenseModel.fromJson(data),
    );
  }

  /// Get all expenses
  Future<List<ExpenseModel>> getAllExpenses({
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

    return executeListRequest<ExpenseModel>(
      request: () => dio.get('/expenses', queryParameters: queryParameters),
      itemParser: (json) => ExpenseModel.fromJson(json),
    );
  }

  /// Get a single expense by ID
  Future<ExpenseModel> getExpenseById(String id) async {
    return executeRequest<ExpenseModel>(
      request: () => dio.get('/expenses/$id'),
      parser: (data) => ExpenseModel.fromJson(data),
    );
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

    return executeRequest<ExpenseModel>(
      request: () => dio.put('/expenses/$id', data: data),
      parser: (data) => ExpenseModel.fromJson(data),
    );
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/expenses/$id'),
    );
  }
}
