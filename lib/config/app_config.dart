import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration and environment settings
///
/// This class centralizes all configuration values and supports
/// different environments (development, staging, production)
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// Current environment
  static const Environment environment = Environment.development;

  static String pocketbaseUrl = dotenv.env['POCKETBASE_URL'] ?? 'http://localhost:8090';

  /// API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8090/api/collections',
  );

  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: 30,
  );

  /// Feature Flags
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: false,
  );

  static const bool enableOfflineMode = bool.fromEnvironment(
    'ENABLE_OFFLINE_MODE',
    defaultValue: true,
  );

  /// Database Configuration
  static const String databaseName = String.fromEnvironment(
    'DATABASE_NAME',
    defaultValue: 'billkeep.db',
  );

  /// App Metadata
  static const String appName = 'BillKeep';
  static const String appVersion = '1.0.0';

  /// Computed properties
  static bool get isProduction => environment == Environment.production;
  static bool get isDevelopment => environment == Environment.development;
  static bool get isStaging => environment == Environment.staging;

  /// Debug helpers
  static void printConfig() {
    if (isDevelopment) {
      print('=== App Configuration ===');
      print('Environment: ${environment.name}');
      print('API Base URL: $apiBaseUrl');
      print('API Timeout: ${apiTimeout}s');
      print('Analytics: $enableAnalytics');
      print('Crash Reporting: $enableCrashReporting');
      print('Offline Mode: $enableOfflineMode');
      print('Database: $databaseName');
      print('========================');
    }
  }
}

/// Supported app environments
enum Environment {
  development,
  staging,
  production;

  /// Get environment from string
  static Environment fromString(String env) {
    switch (env.toLowerCase()) {
      case 'production':
      case 'prod':
        return Environment.production;
      case 'staging':
      case 'stage':
        return Environment.staging;
      case 'development':
      case 'dev':
      default:
        return Environment.development;
    }
  }
}
