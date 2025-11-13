import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

/// Service to manage user preferences both locally and on the backend
class UserPreferencesService {
  final ApiClient _apiClient;
  SharedPreferences? _prefs;

  // Preference keys
  static const String _themeKey = 'theme_mode';
  static const String _currencyKey = 'default_currency';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _biometricKey = 'biometric_enabled';
  static const String _autoBackupKey = 'auto_backup_enabled';
  static const String _budgetAlertKey = 'budget_alert_enabled';
  static const String _expenseReminderKey = 'expense_reminder_enabled';
  static const String _dateFormatKey = 'date_format';
  static const String _timeFormatKey = 'time_format';

  UserPreferencesService() : _apiClient = ApiClient();

  /// Initialize SharedPreferences
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== Local Storage Methods ====================

  /// Get theme mode (light, dark, system)
  Future<String> getThemeMode() async {
    await _ensureInitialized();
    return _prefs!.getString(_themeKey) ?? 'system';
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    await _ensureInitialized();
    await _prefs!.setString(_themeKey, mode);
  }

  /// Get default currency
  Future<String> getDefaultCurrency() async {
    await _ensureInitialized();
    return _prefs!.getString(_currencyKey) ?? 'USD';
  }

  /// Set default currency
  Future<void> setDefaultCurrency(String currency) async {
    await _ensureInitialized();
    await _prefs!.setString(_currencyKey, currency);
  }

  /// Get language
  Future<String> getLanguage() async {
    await _ensureInitialized();
    return _prefs!.getString(_languageKey) ?? 'en';
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    await _ensureInitialized();
    await _prefs!.setString(_languageKey, language);
  }

  /// Get notifications enabled status
  Future<bool> getNotificationsEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(_notificationsKey) ?? true;
  }

  /// Set notifications enabled status
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(_notificationsKey, enabled);
  }

  /// Get biometric enabled status
  Future<bool> getBiometricEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(_biometricKey) ?? false;
  }

  /// Set biometric enabled status
  Future<void> setBiometricEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(_biometricKey, enabled);
  }

  /// Get auto backup enabled status
  Future<bool> getAutoBackupEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(_autoBackupKey) ?? false;
  }

  /// Set auto backup enabled status
  Future<void> setAutoBackupEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(_autoBackupKey, enabled);
  }

  /// Get budget alert enabled status
  Future<bool> getBudgetAlertEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(_budgetAlertKey) ?? true;
  }

  /// Set budget alert enabled status
  Future<void> setBudgetAlertEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(_budgetAlertKey, enabled);
  }

  /// Get expense reminder enabled status
  Future<bool> getExpenseReminderEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(_expenseReminderKey) ?? false;
  }

  /// Set expense reminder enabled status
  Future<void> setExpenseReminderEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(_expenseReminderKey, enabled);
  }

  /// Get date format
  Future<String> getDateFormat() async {
    await _ensureInitialized();
    return _prefs!.getString(_dateFormatKey) ?? 'MM/dd/yyyy';
  }

  /// Set date format
  Future<void> setDateFormat(String format) async {
    await _ensureInitialized();
    await _prefs!.setString(_dateFormatKey, format);
  }

  /// Get time format
  Future<String> getTimeFormat() async {
    await _ensureInitialized();
    return _prefs!.getString(_timeFormatKey) ?? '12h';
  }

  /// Set time format
  Future<void> setTimeFormat(String format) async {
    await _ensureInitialized();
    await _prefs!.setString(_timeFormatKey, format);
  }

  /// Get all preferences as a map
  Future<Map<String, dynamic>> getAllPreferences() async {
    await _ensureInitialized();
    return {
      'themeMode': await getThemeMode(),
      'defaultCurrency': await getDefaultCurrency(),
      'language': await getLanguage(),
      'notificationsEnabled': await getNotificationsEnabled(),
      'biometricEnabled': await getBiometricEnabled(),
      'autoBackupEnabled': await getAutoBackupEnabled(),
      'budgetAlertEnabled': await getBudgetAlertEnabled(),
      'expenseReminderEnabled': await getExpenseReminderEnabled(),
      'dateFormat': await getDateFormat(),
      'timeFormat': await getTimeFormat(),
    };
  }

  /// Clear all local preferences
  Future<void> clearAllPreferences() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  // ==================== Backend API Methods ====================

  /// Fetch user preferences from backend
  Future<Map<String, dynamic>> fetchPreferencesFromBackend(
    String userId,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/preferences/records',
        queryParameters: {'filter': 'user="$userId"'},
      );
      print(response.data);
      if (response.data['items'] != null && response.data['items'].isNotEmpty) {
        print({
          ...response.data['items'][0]['preferences'],
          'id': response.data['items'][0]['id'],
        });
        return {
          ...response.data['items'][0]['preferences'],
          'id': response.data['items'][0]['id'] as String,
        };
      }

      // Return default preferences if none found
      return {};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create user preferences on backend
  Future<Map<String, dynamic>> createPreferencesOnBackend({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final data = {'user': userId, 'preferences': jsonEncode(preferences)};
      print(data);
      final response = await _apiClient.dio.post(
        '/preferences/records',
        data: data,
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update user preferences on backend
  Future<Map<String, dynamic>> updatePreferencesOnBackend({
    required String recordId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final response = await _apiClient.dio.patch(
        '/preferences/records/$recordId',
        data: preferences,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete user preferences from backend
  Future<void> deletePreferencesFromBackend(String recordId) async {
    try {
      await _apiClient.dio.delete('/user_preferences/records/$recordId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sync local preferences to backend
  Future<void> syncToBackend(String userId) async {
    try {
      final localPrefs = await getAllPreferences();

      // Check if preferences already exist on backend
      final existingPrefs = await fetchPreferencesFromBackend(userId);

      if (existingPrefs.isEmpty) {
        // Create new preferences
        await createPreferencesOnBackend(
          userId: userId,
          preferences: localPrefs,
        );
      } else {
        // Update existing preferences
        await updatePreferencesOnBackend(
          recordId: existingPrefs['id'],
          preferences: localPrefs,
        );
      }
    } catch (e) {
      throw 'Failed to sync preferences to backend: $e';
    }
  }

  /// Sync backend preferences to local storage
  Future<void> syncFromBackend(String userId) async {
    try {
      final backendPrefs = await fetchPreferencesFromBackend(userId);

      if (backendPrefs.isNotEmpty) {
        // Update local preferences with backend data
        if (backendPrefs['themeMode'] != null) {
          await setThemeMode(backendPrefs['themeMode']);
        }
        if (backendPrefs['defaultCurrency'] != null) {
          await setDefaultCurrency(backendPrefs['defaultCurrency']);
        }
        if (backendPrefs['language'] != null) {
          await setLanguage(backendPrefs['language']);
        }
        if (backendPrefs['notificationsEnabled'] != null) {
          await setNotificationsEnabled(backendPrefs['notificationsEnabled']);
        }
        if (backendPrefs['biometricEnabled'] != null) {
          await setBiometricEnabled(backendPrefs['biometricEnabled']);
        }
        if (backendPrefs['autoBackupEnabled'] != null) {
          await setAutoBackupEnabled(backendPrefs['autoBackupEnabled']);
        }
        if (backendPrefs['budgetAlertEnabled'] != null) {
          await setBudgetAlertEnabled(backendPrefs['budgetAlertEnabled']);
        }
        if (backendPrefs['expenseReminderEnabled'] != null) {
          await setExpenseReminderEnabled(
            backendPrefs['expenseReminderEnabled'],
          );
        }
        if (backendPrefs['dateFormat'] != null) {
          await setDateFormat(backendPrefs['dateFormat']);
        }
        if (backendPrefs['timeFormat'] != null) {
          await setTimeFormat(backendPrefs['timeFormat']);
        }
      }
    } catch (e) {
      throw 'Failed to sync preferences from backend: $e';
    }
  }

  /// Perform bi-directional sync (fetch from backend and update local)
  Future<void> performFullSync(String userId) async {
    try {
      // First, fetch from backend to get latest
      await syncFromBackend(userId);
      // Then push any local changes back
      await syncToBackend(userId);
    } catch (e) {
      throw 'Failed to perform full sync: $e';
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
          return data['message'] ?? 'Preferences not found';
        case 409:
          return data['message'] ?? 'Conflict - preferences already exist';
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
