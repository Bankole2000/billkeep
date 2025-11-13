import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../utils/exceptions.dart';

/// Centralized logging service for the application
///
/// Provides consistent logging across the app with different log levels
/// and supports integration with external logging services
class LoggingService {
  // Private constructor for singleton
  LoggingService._();

  static final LoggingService _instance = LoggingService._();
  static LoggingService get instance => _instance;

  /// Log levels
  static const int _levelDebug = 0;
  static const int _levelInfo = 1;
  static const int _levelWarning = 2;
  static const int _levelError = 3;
  static const int _levelCritical = 4;

  /// Current minimum log level (only logs at this level or higher will be recorded)
  int _minLogLevel = _levelDebug;

  /// Enable/disable logging
  bool _enabled = true;

  /// Configure the logging service
  void configure({bool? enabled, bool debugOnly = false}) {
    _enabled = enabled ?? _enabled;

    // In production, only log warnings and above
    if (AppConfig.isProduction || !kDebugMode) {
      _minLogLevel = _levelWarning;
    } else if (debugOnly) {
      _minLogLevel = _levelDebug;
    }
  }

  /// Log a debug message
  /// Use for detailed debugging information
  static void debug(String message, {String? tag, Object? data}) {
    _instance._log(_levelDebug, message, tag: tag, data: data);
  }

  /// Log an info message
  /// Use for general informational messages
  static void info(String message, {String? tag, Object? data}) {
    _instance._log(_levelInfo, message, tag: tag, data: data);
  }

  /// Log a warning message
  /// Use for non-critical issues that should be investigated
  static void warning(String message, {String? tag, Object? data}) {
    _instance._log(_levelWarning, message, tag: tag, data: data);
  }

  /// Log an error message
  /// Use for errors that don't crash the app but affect functionality
  static void error(
    String message, {
    String? tag,
    Object? error,
    Object? data,
    StackTrace? stackTrace,
  }) {
    _instance._log(
      _levelError,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a critical error
  /// Use for severe errors that might crash the app
  static void critical(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _instance._log(
      _levelCritical,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    // TODO: Send to crash reporting service (Firebase Crashlytics, Sentry, etc.)
    if (AppConfig.enableCrashReporting) {
      _instance._sendToCrashReporting(message, error, stackTrace);
    }
  }

  /// Log an exception
  /// Automatically determines log level based on exception type
  static void exception(
    Object exception, {
    StackTrace? stackTrace,
    String? context,
  }) {
    final String message = context != null
        ? '$context: ${exception.toString()}'
        : exception.toString();

    if (exception is AppException) {
      // Application exceptions are expected, log as error
      error(
        message,
        tag: exception.runtimeType.toString(),
        error: exception,
        stackTrace: stackTrace,
      );
    } else {
      // Unexpected exceptions are critical
      critical(
        message,
        tag: 'UnhandledException',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log network request
  static void networkRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    Object? body,
  }) {
    if (!AppConfig.isDevelopment) return;

    debug(
      'HTTP $method $url',
      tag: 'Network',
      data: {'headers': headers, 'body': body},
    );
  }

  /// Log network response
  static void networkResponse(
    int statusCode,
    String url, {
    Object? body,
    Duration? duration,
  }) {
    if (!AppConfig.isDevelopment) return;

    debug(
      'HTTP $statusCode $url ${duration != null ? "(${duration.inMilliseconds}ms)" : ""}',
      tag: 'Network',
      data: body,
    );
  }

  /// Log database operation
  static void database(String operation, {String? table, Object? data}) {
    if (!AppConfig.isDevelopment) return;

    debug(
      'DB: $operation${table != null ? " on $table" : ""}',
      tag: 'Database',
      data: data,
    );
  }

  /// Log sync operation
  static void sync(String operation, {String? entity, Object? data}) {
    info(
      'Sync: $operation${entity != null ? " ($entity)" : ""}',
      tag: 'Sync',
      data: data,
    );
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? properties}) {
    info('User: $action', tag: 'Analytics', data: properties);

    // TODO: Send to analytics service (Firebase Analytics, Mixpanel, etc.)
    if (AppConfig.enableAnalytics) {
      _instance._sendToAnalytics(action, properties);
    }
  }

  /// Internal logging method
  void _log(
    int level,
    String message, {
    String? tag,
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled || level < _minLogLevel) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = _getLevelString(level);
    final tagStr = tag != null ? '[$tag] ' : '';
    final logMessage = '$timestamp $levelStr $tagStr$message';

    // Print to console (only in debug mode)
    if (kDebugMode) {
      print(logMessage);

      if (data != null) {
        print('  Data: $data');
      }

      if (error != null) {
        print('  Error: $error');
      }

      if (stackTrace != null) {
        print('  Stack trace:\n$stackTrace');
      }
    }

    // TODO: Write to file for persistent logging
    // TODO: Send to remote logging service
  }

  /// Get string representation of log level
  String _getLevelString(int level) {
    switch (level) {
      case _levelDebug:
        return '[DEBUG]';
      case _levelInfo:
        return '[INFO] ';
      case _levelWarning:
        return '[WARN] ';
      case _levelError:
        return '[ERROR]';
      case _levelCritical:
        return '[FATAL]';
      default:
        return '[LOG]  ';
    }
  }

  /// Send to crash reporting service (placeholder)
  void _sendToCrashReporting(
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // TODO: Implement Firebase Crashlytics or Sentry integration
    // Example:
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
  }

  /// Send to analytics service (placeholder)
  void _sendToAnalytics(String event, Map<String, dynamic>? properties) {
    // TODO: Implement Firebase Analytics or Mixpanel integration
    // Example:
    // FirebaseAnalytics.instance.logEvent(name: event, parameters: properties);
  }
}

/// Extension to log exceptions easily
extension ExceptionLogging on Object {
  void log({StackTrace? stackTrace, String? context}) {
    LoggingService.exception(this, stackTrace: stackTrace, context: context);
  }
}
