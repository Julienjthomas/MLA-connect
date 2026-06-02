import 'app_flavor.dart';

class AppConfig {
  AppConfig._();

  static late AppFlavor flavor;
  static late String supabaseUrl;
  static late String supabaseAnonKey;
  static late String appName;
  static late bool debugBanner;

  static void init(AppFlavor f) {
    flavor = f;

    // All flavors share one Supabase project for now.
    // Swap per-flavor values here when separate projects exist.
    supabaseUrl = 'https://lebvnbqjhvvfmesrmwal.supabase.co';
    supabaseAnonKey = 'sb_publishable_WjPe8mYSY6eNq9YBTTMSbg_l2Z8cjr5';

    switch (f) {
      case AppFlavor.dev:
        appName = 'MLA Connect Dev';
        debugBanner = false;
      case AppFlavor.stg:
        appName = 'MLA Connect Stg';
        debugBanner = false;
      case AppFlavor.prod:
        appName = 'MLA Connect';
        debugBanner = false;
    }
  }
}
