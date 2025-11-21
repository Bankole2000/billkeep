import 'package:pocketbase/pocketbase.dart';
import '../models/budget_model.dart';
import 'base_api_service.dart';

class BudgetService extends BaseApiService {
  BudgetService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for budgets collection
  void _setupRealtimeSync() {
    subscribeToCollection('budgets', _handleBudgetUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleBudgetUpdate(RecordSubscriptionEvent event) {
    print('🔄 Budget ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncBudgetFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle budget deletion in local DB if needed
            print('🗑️ Budget deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling budget update: $e');
    }
  }

  /// Sync budget from backend to local DB
  Future<void> _syncBudgetFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing budget: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing budget: $e');
    }
  }

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
    return executeRequest<BudgetModel>(
      request: () => dio.post(
        '/budgets/records',
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
      ),
      parser: (data) => BudgetModel.fromJson(data),
    );
  }

  /// Get all budgets
  Future<List<BudgetModel>> getAllBudgets({
    String? projectId,
    String? categoryId,
    bool? isActive,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (projectId != null) queryParameters['projectId'] = projectId;
    if (categoryId != null) queryParameters['categoryId'] = categoryId;
    if (isActive != null) queryParameters['isActive'] = isActive;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<BudgetModel>(
      request: () => dio.get('/budgets', queryParameters: queryParameters),
      itemParser: (json) => BudgetModel.fromJson(json),
    );
  }

  /// Get a single budget by ID
  Future<BudgetModel> getBudgetById(String id) async {
    return executeRequest<BudgetModel>(
      request: () => dio.get('/budgets/$id'),
      parser: (data) => BudgetModel.fromJson(data),
    );
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

    return executeRequest<BudgetModel>(
      request: () => dio.put('/budgets/$id', data: data),
      parser: (data) => BudgetModel.fromJson(data),
    );
  }

  /// Delete a budget
  Future<void> deleteBudget(String id) async {
    return executeVoidRequest(request: () => dio.delete('/budgets/$id'));
  }
}
