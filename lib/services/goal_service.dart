import 'package:pocketbase/pocketbase.dart';
import '../models/goal_model.dart';
import 'base_api_service.dart';

class GoalService extends BaseApiService {
  GoalService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for goals collection
  void _setupRealtimeSync() {
    subscribeToCollection('goals', _handleGoalUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleGoalUpdate(RecordSubscriptionEvent event) {
    print('🔄 Goal ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncGoalFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle goal deletion in local DB if needed
            print('🗑️ Goal deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling goal update: $e');
    }
  }

  /// Sync goal from backend to local DB
  Future<void> _syncGoalFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing goal: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing goal: $e');
    }
  }

  /// Create a new goal
  Future<GoalModel> createGoal({
    required String name,
    required String type,
    required int targetAmount,
    String? contactId,
    String? categoryId,
    int? currentAmount,
    DateTime? targetDate,
    bool? isCompleted,
    String? description,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    return executeRequest<GoalModel>(
      request: () => dio.post(
        '/goals',
        data: {
          'name': name,
          'type': type,
          'targetAmount': targetAmount,
          'contactId': contactId,
          'categoryId': categoryId,
          'currentAmount': currentAmount,
          'targetDate': targetDate?.toIso8601String(),
          'isCompleted': isCompleted,
          'description': description,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
        },
      ),
      parser: (data) => GoalModel.fromJson(data),
    );
  }

  /// Get all goals
  Future<List<GoalModel>> getAllGoals({
    String? type,
    bool? isCompleted,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (type != null) queryParameters['type'] = type;
    if (isCompleted != null) queryParameters['isCompleted'] = isCompleted;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<GoalModel>(
      request: () => dio.get(
        '/goals',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => GoalModel.fromJson(json),
    );
  }

  /// Get a single goal by ID
  Future<GoalModel> getGoalById(String id) async {
    return executeRequest<GoalModel>(
      request: () => dio.get('/goals/$id'),
      parser: (data) => GoalModel.fromJson(data),
    );
  }

  /// Update an existing goal
  Future<GoalModel> updateGoal({
    required String id,
    String? name,
    String? type,
    int? targetAmount,
    String? contactId,
    String? categoryId,
    int? currentAmount,
    DateTime? targetDate,
    bool? isCompleted,
    String? description,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (targetAmount != null) data['targetAmount'] = targetAmount;
    if (contactId != null) data['contactId'] = contactId;
    if (categoryId != null) data['categoryId'] = categoryId;
    if (currentAmount != null) data['currentAmount'] = currentAmount;
    if (targetDate != null) {
      data['targetDate'] = targetDate.toIso8601String();
    }
    if (isCompleted != null) data['isCompleted'] = isCompleted;
    if (description != null) data['description'] = description;
    if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
    if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
    if (iconType != null) data['iconType'] = iconType;
    if (color != null) data['color'] = color;

    return executeRequest<GoalModel>(
      request: () => dio.put('/goals/$id', data: data),
      parser: (data) => GoalModel.fromJson(data),
    );
  }

  /// Delete a goal
  Future<void> deleteGoal(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/goals/$id'),
    );
  }
}
