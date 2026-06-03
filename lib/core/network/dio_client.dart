import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

/// Factory for creating and configuring the app-wide [Dio] instance.
class DioClient {
  DioClient._();

  /// Creates a fully configured [Dio] instance with all interceptors.
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Order matters: auth → token refresh → error → logger.
    dio.interceptors.addAll([
      AuthInterceptor(),
      TokenRefreshInterceptor(dio: dio),
      ErrorInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
    ]);

    return dio;
  }
}
