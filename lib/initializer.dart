import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/config/app_flavor.dart';
import 'core/network/dio_client.dart';
import 'core/utils/app_locale.dart';
import 'data/remote/appreciation_api.dart';
import 'data/remote/auth_api.dart';
import 'data/remote/concern_api.dart';
import 'data/remote/conversations_api.dart';
import 'data/remote/events_api.dart';
import 'data/remote/geography_api.dart';
import 'data/remote/idea_api.dart';
import 'data/remote/mla_api.dart';
import 'data/remote/notification_api.dart';
import 'data/remote/profile_api.dart';
import 'data/remote/updates_api.dart';
import 'data/services/app_config_service.dart';
import 'features/auth/controllers/auth_controller.dart';

class Initializer {
  static final Initializer instance = Initializer._internal();

  factory Initializer() => instance;

  Initializer._internal();

  Future<void> init(AppFlavor flavor, VoidCallback runApp) async {
    WidgetsFlutterBinding.ensureInitialized();

    AppConfig.init(flavor);

    await _setPreferredOrientations();
    await _initSupabase();
    _registerDependencies();
    await _initLocale();

    runApp();
  }

  Future<void> _setPreferredOrientations() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initSupabase() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      debug: AppConfig.flavor == AppFlavor.dev,
    );
  }

  void _registerDependencies() {
    final dio = DioClient.create();
    Get.put<Dio>(dio, permanent: true);

    Get
      ..lazyPut<AuthApi>(() => AuthApi(Get.find<Dio>()))
      ..lazyPut<ProfileApi>(() => ProfileApi(Get.find<Dio>()))
      ..lazyPut<GeographyApi>(() => GeographyApi(Get.find<Dio>()))
      ..lazyPut<ConcernApi>(() => ConcernApi(Get.find<Dio>()))
      ..lazyPut<AppreciationApi>(() => AppreciationApi(Get.find<Dio>()))
      ..lazyPut<MlaApi>(() => MlaApi(Get.find<Dio>()))
      ..lazyPut<UpdatesApi>(() => UpdatesApi(Get.find<Dio>()))
      ..lazyPut<EventsApi>(() => EventsApi(Get.find<Dio>()))
      ..lazyPut<ConversationsApi>(() => ConversationsApi(Get.find<Dio>()))
      ..lazyPut<IdeaApi>(() => IdeaApi(Get.find<Dio>()))
      ..lazyPut<NotificationApi>(() => NotificationApi(Get.find<Dio>()));

    Get
      ..put(AppConfigService(), permanent: true)
      ..put(AuthController(), permanent: true);
  }

  Future<void> _initLocale() async {
    final localeCode = await AppLocale.load();
    if (await AppLocale.hasStoredPreference()) {
      Get.updateLocale(Locale(localeCode));
    }
  }
}
