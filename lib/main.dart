import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'data/supabase/supabase_config.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  Get.put(AuthController(), permanent: true);

  runApp(const SuperBalusseryApp());
}

class SuperBalusseryApp extends StatelessWidget {
  const SuperBalusseryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Super Balussery',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
