import 'app_flavor.dart';
import 'env/env.dart';

class AppConfig {
  AppConfig._();

  static late AppFlavor flavor;
  static late String baseUrl;
  static late String appName;
  static late bool debugBanner;

  // TODO: Remove after full Supabase migration
  static const supabaseUrl = 'https://lebvnbqjhvvfmesrmwal.supabase.co';
  static const supabaseAnonKey = 'sb_publishable_WjPe8mYSY6eNq9YBTTMSbg_l2Z8cjr5';

  static void init(AppFlavor f) {
    flavor = f;

    baseUrl = Env.baseUrl;

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
