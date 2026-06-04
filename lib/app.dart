import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_locale.dart';
import 'core/widgets/app_config_wrapper.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class MlaConnectApp extends StatefulWidget {
  const MlaConnectApp({super.key});

  @override
  State<MlaConnectApp> createState() => _MlaConnectAppState();
}

class _MlaConnectAppState extends State<MlaConnectApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: AppConfig.debugBanner,
            theme: buildAppTheme(),
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            locale: Locale(AppLocale.languageCode.value),
            fallbackLocale: const Locale('en'),
            initialRoute: Routes.splash,
            getPages: AppPages.pages,
            defaultTransition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 280),
            builder: (context, child) => AppConfigWrapper(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}
