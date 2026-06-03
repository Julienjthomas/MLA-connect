import 'dart:io';

import 'package:dio/dio.dart';

import '../api_exceptions.dart';

/// Maps Dio errors to typed [AppException] subtypes.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  AppException _mapException(DioException err) {
    // Network-level failures.
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.error is SocketException) {
      return const NetworkException();
    }

    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    if (statusCode == null) {
      return const UnknownException();
    }

    return switch (statusCode) {
      401 => const UnauthorizedException(),
      404 => const NotFoundException(),
      422 => _parseValidationError(data),
      >= 500 => ServerException(
          statusCode: statusCode,
          message: _messageFromData(data) ?? 'Server error',
        ),
      _ => UnknownException(
          _messageFromData(data) ?? 'Request failed ($statusCode)',
        ),
    };
  }

  ValidationException _parseValidationError(dynamic data) {
    final errors = <String, List<String>>{};
    if (data is Map<String, dynamic> && data['errors'] is Map) {
      final raw = data['errors'] as Map<String, dynamic>;
      for (final entry in raw.entries) {
        if (entry.value is List) {
          errors[entry.key] =
              (entry.value as List).map((e) => e.toString()).toList();
        }
      }
    }
    return ValidationException(errors: errors);
  }

  String? _messageFromData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }
}
