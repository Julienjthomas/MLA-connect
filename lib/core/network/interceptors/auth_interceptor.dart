import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Injects JWT token into Authorization header and replaces
/// `:citizenId` placeholder in request paths.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _citizenIdKey = 'citizen_id';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Inject JWT token.
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Replace :citizenId placeholder in path.
    if (options.path.contains(':citizenId')) {
      final citizenId = await _storage.read(key: _citizenIdKey);
      if (citizenId != null && citizenId.isNotEmpty) {
        options.path = options.path.replaceAll(':citizenId', citizenId);
      }
    }

    handler.next(options);
  }
}
