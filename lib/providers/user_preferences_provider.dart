import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_preferences_service.dart';

// Service provider
final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService();
});

// State provider for default currency code
final defaultCurrencyProvider = StateProvider<String>((ref) => 'USD');

// State provider for theme mode
final themeModeProvider = StateProvider<String>((ref) => 'system');

// State provider for language
final languageProvider = StateProvider<String>((ref) => 'en');

// State provider for notifications enabled
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

// State provider for biometric enabled
final biometricEnabledProvider = StateProvider<bool>((ref) => false);

// State provider for auto backup enabled
final autoBackupEnabledProvider = StateProvider<bool>((ref) => false);

// State provider for budget alert enabled
final budgetAlertEnabledProvider = StateProvider<bool>((ref) => true);

// State provider for expense reminder enabled
final expenseReminderEnabledProvider = StateProvider<bool>((ref) => false);

// State provider for date format
final dateFormatProvider = StateProvider<String>((ref) => 'MM/dd/yyyy');

// State provider for time format
final timeFormatProvider = StateProvider<String>((ref) => '12h');

// Provider to load all preferences from SharedPreferences
final loadPreferencesProvider = FutureProvider<void>((ref) async {
  final prefsService = ref.read(userPreferencesServiceProvider);

  // Load all preferences from SharedPreferences
  final defaultCurrency = await prefsService.getDefaultCurrency();
  final themeMode = await prefsService.getThemeMode();
  final language = await prefsService.getLanguage();
  final notificationsEnabled = await prefsService.getNotificationsEnabled();
  final biometricEnabled = await prefsService.getBiometricEnabled();
  final autoBackupEnabled = await prefsService.getAutoBackupEnabled();
  final budgetAlertEnabled = await prefsService.getBudgetAlertEnabled();
  final expenseReminderEnabled = await prefsService.getExpenseReminderEnabled();
  final dateFormat = await prefsService.getDateFormat();
  final timeFormat = await prefsService.getTimeFormat();

  // Update the state providers with loaded values
  ref.read(defaultCurrencyProvider.notifier).state = defaultCurrency;
  ref.read(themeModeProvider.notifier).state = themeMode;
  ref.read(languageProvider.notifier).state = language;
  ref.read(notificationsEnabledProvider.notifier).state = notificationsEnabled;
  ref.read(biometricEnabledProvider.notifier).state = biometricEnabled;
  ref.read(autoBackupEnabledProvider.notifier).state = autoBackupEnabled;
  ref.read(budgetAlertEnabledProvider.notifier).state = budgetAlertEnabled;
  ref.read(expenseReminderEnabledProvider.notifier).state =
      expenseReminderEnabled;
  ref.read(dateFormatProvider.notifier).state = dateFormat;
  ref.read(timeFormatProvider.notifier).state = timeFormat;
});

// Helper class to manage preferences with auto-save
class UserPreferencesNotifier extends StateNotifier<Map<String, dynamic>> {
  final UserPreferencesService _prefsService;

  UserPreferencesNotifier(this._prefsService) : super({});

  // Update default currency and save to SharedPreferences
  Future<void> setDefaultCurrency(String currency) async {
    await _prefsService.setDefaultCurrency(currency);
    state = {...state, 'defaultCurrency': currency};
  }

  // Update theme mode and save to SharedPreferences
  Future<void> setThemeMode(String mode) async {
    await _prefsService.setThemeMode(mode);
    state = {...state, 'themeMode': mode};
  }

  // Update language and save to SharedPreferences
  Future<void> setLanguage(String language) async {
    await _prefsService.setLanguage(language);
    state = {...state, 'language': language};
  }

  // Update notifications enabled and save to SharedPreferences
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefsService.setNotificationsEnabled(enabled);
    state = {...state, 'notificationsEnabled': enabled};
  }

  // Update biometric enabled and save to SharedPreferences
  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefsService.setBiometricEnabled(enabled);
    state = {...state, 'biometricEnabled': enabled};
  }

  // Update auto backup enabled and save to SharedPreferences
  Future<void> setAutoBackupEnabled(bool enabled) async {
    await _prefsService.setAutoBackupEnabled(enabled);
    state = {...state, 'autoBackupEnabled': enabled};
  }

  // Update budget alert enabled and save to SharedPreferences
  Future<void> setBudgetAlertEnabled(bool enabled) async {
    await _prefsService.setBudgetAlertEnabled(enabled);
    state = {...state, 'budgetAlertEnabled': enabled};
  }

  // Update expense reminder enabled and save to SharedPreferences
  Future<void> setExpenseReminderEnabled(bool enabled) async {
    await _prefsService.setExpenseReminderEnabled(enabled);
    state = {...state, 'expenseReminderEnabled': enabled};
  }

  // Update date format and save to SharedPreferences
  Future<void> setDateFormat(String format) async {
    await _prefsService.setDateFormat(format);
    state = {...state, 'dateFormat': format};
  }

  // Update time format and save to SharedPreferences
  Future<void> setTimeFormat(String format) async {
    await _prefsService.setTimeFormat(format);
    state = {...state, 'timeFormat': format};
  }

  // Load all preferences
  Future<void> loadPreferences() async {
    state = await _prefsService.getAllPreferences();
  }

  // Clear all preferences
  Future<void> clearPreferences() async {
    await _prefsService.clearAllPreferences();
    state = {};
  }

  // Sync to backend
  Future<void> syncToBackend(String userId) async {
    await _prefsService.syncToBackend(userId);
  }

  // Sync from backend
  Future<void> syncFromBackend(String userId) async {
    await _prefsService.syncFromBackend(userId);
    await loadPreferences();
  }

  // Perform full sync
  Future<void> performFullSync(String userId) async {
    await _prefsService.performFullSync(userId);
    await loadPreferences();
  }
}

// State notifier provider for managing preferences
final userPreferencesNotifierProvider =
    StateNotifierProvider<UserPreferencesNotifier, Map<String, dynamic>>((ref) {
  final prefsService = ref.watch(userPreferencesServiceProvider);
  return UserPreferencesNotifier(prefsService);
});
