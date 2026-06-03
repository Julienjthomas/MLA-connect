import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;

import '../../config/app_config.dart';
import '../api_exceptions.dart';

/// Handles 401 responses by refreshing the JWT token and retrying.
///
/// Queues concurrent requests while a refresh is in progress so only
/// one refresh call is made at a time.
class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required Dio dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio,
        _storage = storage ?? const FlutterSecureStorage();

  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _citizenIdKey = 'citizen_id';

  bool _isRefreshing = false;
  final _queue = <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      // Queue this request — it will be retried after refresh.
      _queue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        _rejectAll(err);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const UnauthorizedException(),
          ),
        );
        _clearSessionAndNavigateToLogin();
        return;
      }

      // Retry original request.
      final response = await _retry(err.requestOptions);
      handler.resolve(response);

      // Retry queued requests.
      _retryQueue();
    } catch (_) {
      _rejectAll(err);
      handler.reject(err);
      _clearSessionAndNavigateToLogin();
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      final citizenId = await _storage.read(key: _citizenIdKey);
      if (refreshToken == null || citizenId == null) return false;

      final response = await Dio().post(
        '${AppConfig.baseUrl}/citizens/$citizenId/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newToken = response.data['token'] as String?;
      final newRefresh = response.data['refreshToken'] as String?;
      if (newToken == null) return false;

      await _storage.write(key: _tokenKey, value: newToken);
      if (newRefresh != null) {
        await _storage.write(key: _refreshTokenKey, value: newRefresh);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions options) async {
    final token = await _storage.read(key: _tokenKey);
    options.headers['Authorization'] = 'Bearer $token';
    return _dio.fetch(options);
  }

  void _retryQueue() {
    final pending = List.of(_queue);
    _queue.clear();
    for (final item in pending) {
      _retry(item.options).then(
        item.handler.resolve,
        onError: (e) => item.handler.reject(
          e is DioException
              ? e
              : DioException(requestOptions: item.options, error: e),
        ),
      );
    }
  }

  void _rejectAll(DioException err) {
    for (final item in _queue) {
      item.handler.reject(
        DioException(
          requestOptions: item.options,
          error: const UnauthorizedException(),
        ),
      );
    }
    _queue.clear();
  }

  void _clearSessionAndNavigateToLogin() {
    _storage.delete(key: _tokenKey);
    _storage.delete(key: _refreshTokenKey);
    _storage.delete(key: _citizenIdKey);
    // Navigate to login — GetX named route.
    Get.offAllNamed('/phone');
  }
}
