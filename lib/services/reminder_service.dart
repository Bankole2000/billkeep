import 'package:dio/dio.dart';
import '../models/reminder_model.dart';
import 'api_client.dart';

class ReminderService {
  final ApiClient _apiClient;

  ReminderService() : _apiClient = ApiClient();

  /// Create a new reminder
  Future<ReminderModel> createReminder({
    required DateTime reminderDate,
    bool? isActive,
    required String reminderType,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/reminders',
        data: {
          'reminderDate': reminderDate.toIso8601String(),
          'isActive': isActive,
          'reminderType': reminderType,
        },
      );

      return ReminderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all reminders
  Future<List<ReminderModel>> getAllReminders({
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
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

      final response = await _apiClient.dio.get(
        '/reminders',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((reminder) => ReminderModel.fromJson(reminder))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((reminder) => ReminderModel.fromJson(reminder))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single reminder by ID
  Future<ReminderModel> getReminderById(String id) async {
    try {
      final response = await _apiClient.dio.get('/reminders/$id');
      return ReminderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing reminder
  Future<ReminderModel> updateReminder({
    required String id,
    DateTime? reminderDate,
    bool? isActive,
    String? reminderType,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (reminderDate != null) {
        data['reminderDate'] = reminderDate.toIso8601String();
      }
      if (isActive != null) data['isActive'] = isActive;
      if (reminderType != null) data['reminderType'] = reminderType;

      final response = await _apiClient.dio.put('/reminders/$id', data: data);
      return ReminderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(String id) async {
    try {
      await _apiClient.dio.delete('/reminders/$id');
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
          return data['message'] ?? 'Reminder not found';
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
