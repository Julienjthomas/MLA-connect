/// Base exception for all API errors.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// No internet connection.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Server returned 5xx.
class ServerException extends AppException {
  const ServerException({required this.statusCode, required String message})
      : super(message);
  final int statusCode;
}

/// 401 after token refresh also failed.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired']);
}

/// 404 Not Found.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

/// 422 with field-level validation errors.
class ValidationException extends AppException {
  const ValidationException({
    required this.errors,
    String message = 'Validation failed',
  }) : super(message);

  /// Field name → list of error messages.
  final Map<String, List<String>> errors;
}

/// Catch-all for unmapped errors.
class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong']);
}
