import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/app_flavor.dart';
import 'core/network/dio_client.dart';
import 'core/utils/app_locale.dart';
import 'features/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.init(AppFlavor.stg);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: false,
  );

  Get.put<Dio>(DioClient.create(), permanent: true);

  Get.put(AuthController(), permanent: true);

  final localeCode = await AppLocale.load();
  if (await AppLocale.hasStoredPreference()) {
    Get.updateLocale(Locale(localeCode));
  }

  runApp(const MlaConnectApp());
}
