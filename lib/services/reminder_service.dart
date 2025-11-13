import '../models/reminder_model.dart';
import 'base_api_service.dart';

class ReminderService extends BaseApiService {
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
