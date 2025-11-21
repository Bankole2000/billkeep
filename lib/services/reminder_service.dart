import 'package:pocketbase/pocketbase.dart';
import '../models/reminder_model.dart';
import 'base_api_service.dart';

class ReminderService extends BaseApiService {
  ReminderService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for reminders collection
  void _setupRealtimeSync() {
    subscribeToCollection('reminders', _handleReminderUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleReminderUpdate(RecordSubscriptionEvent event) {
    print('🔄 Reminder ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncReminderFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle reminder deletion in local DB if needed
            print('🗑️ Reminder deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling reminder update: $e');
    }
  }

  /// Sync reminder from backend to local DB
  Future<void> _syncReminderFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing reminder: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing reminder: $e');
    }
  }

  /// Create a new reminder
  Future<ReminderModel> createReminder({
    required DateTime reminderDate,
    bool? isActive,
    required String reminderType,
  }) async {
    return executeRequest<ReminderModel>(
      request: () => dio.post(
        '/reminders',
        data: {
          'reminderDate': reminderDate.toIso8601String(),
          'isActive': isActive,
          'reminderType': reminderType,
        },
      ),
      parser: (data) => ReminderModel.fromJson(data),
    );
  }

  /// Get all reminders
  Future<List<ReminderModel>> getAllReminders({
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (isActive != null) queryParameters['isActive'] = isActive;
    if (startDate != null) {
      queryParameters['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParameters['endDate'] = endDate.toIso8601String();
    }
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<ReminderModel>(
      request: () => dio.get(
        '/reminders',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => ReminderModel.fromJson(json),
    );
  }

  /// Get a single reminder by ID
  Future<ReminderModel> getReminderById(String id) async {
    return executeRequest<ReminderModel>(
      request: () => dio.get('/reminders/$id'),
      parser: (data) => ReminderModel.fromJson(data),
    );
  }

  /// Update an existing reminder
  Future<ReminderModel> updateReminder({
    required String id,
    DateTime? reminderDate,
    bool? isActive,
    String? reminderType,
  }) async {
    final data = <String, dynamic>{};

    if (reminderDate != null) {
      data['reminderDate'] = reminderDate.toIso8601String();
    }
    if (isActive != null) data['isActive'] = isActive;
    if (reminderType != null) data['reminderType'] = reminderType;

    return executeRequest<ReminderModel>(
      request: () => dio.put('/reminders/$id', data: data),
      parser: (data) => ReminderModel.fromJson(data),
    );
  }

  /// Delete a reminder
  Future<void> deleteReminder(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/reminders/$id'),
    );
  }
}
