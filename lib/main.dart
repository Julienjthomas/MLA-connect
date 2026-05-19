import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_locale.dart';
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
    debug: true,
  );

  Get.put(AuthController(), permanent: true);

  final localeCode = await AppLocale.load();
  if (await AppLocale.hasStoredPreference()) {
    Get.updateLocale(Locale(localeCode));
  }

  runApp(const SuperBalusseryApp());
}

class SuperBalusseryApp extends StatefulWidget {
  const SuperBalusseryApp({super.key});

  @override
  State<SuperBalusseryApp> createState() => _SuperBalusseryAppState();
}

class _SuperBalusseryAppState extends State<SuperBalusseryApp> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'MLA Connect',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        locale: Locale(AppLocale.languageCode.value),
        fallbackLocale: const Locale('en'),
        initialRoute: Routes.splash,
        getPages: AppPages.pages,
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }
}
