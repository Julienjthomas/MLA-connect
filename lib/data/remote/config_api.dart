import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/network/api_endpoints.dart';
import '../models/app_config_model.dart';

part 'config_api.g.dart';

/// Example retrofit API client — pattern for all future API clients.
///
/// Usage:
/// 1. Define abstract class with @RestApi()
/// 2. Add methods with HTTP annotations (@GET, @POST, etc.)
/// 3. Run: dart run build_runner build
/// 4. Register in GetX DI: Get.lazyPut(() => ConfigApi(Get.find<Dio>()))
@RestApi()
abstract class ConfigApi {
  factory ConfigApi(Dio dio, {String? baseUrl}) = _ConfigApi;

  @GET(ApiEndpoints.appConfig)
  Future<AppConfigModel> getAppConfig();
}
