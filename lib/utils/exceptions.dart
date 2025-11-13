/// Base class for all application exceptions
///
/// All custom exceptions should extend this class to provide
/// consistent error handling throughout the application
abstract class AppException implements Exception {
  /// Technical error message (for logging/debugging)
  final String message;

  /// User-friendly error message (for displaying to users)
  final String? userMessage;

  AppException(this.message, [this.userMessage]);

  @override
  String toString() => message;

  /// Get the message to display to the user
  String getUserMessage() => userMessage ?? message;
}

/// Exception thrown when network/connectivity issues occur
class NetworkException extends AppException {
  NetworkException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when authentication fails (401)
class AuthenticationException extends AppException {
  AuthenticationException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when user doesn't have permission (403)
class AuthorizationException extends AppException {
  AuthorizationException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when a resource is not found (404)
class NotFoundException extends AppException {
  NotFoundException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when validation fails (400)
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    String message, [
    String? userMessage,
    this.fieldErrors,
  ]) : super(message, userMessage);
}

/// Exception thrown when a conflict occurs (409)
class ConflictException extends AppException {
  ConflictException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when server errors occur (500+)
class ServerException extends AppException {
  ServerException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when database operations fail
class DatabaseException extends AppException {
  DatabaseException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when data sync fails
class SyncException extends AppException {
  SyncException(String message, [String? userMessage])
      : super(message, userMessage);
}

/// Exception thrown when business logic validation fails
class BusinessLogicException extends AppException {
  BusinessLogicException(String message, [String? userMessage])
      : super(message, userMessage);
}
