import 'package:get/get.dart';

import '../features/onboarding/bindings/onboarding_binding.dart';
import '../features/onboarding/views/splash_view.dart';
import '../features/onboarding/views/welcome_view.dart';
import '../features/onboarding/views/language_view.dart';
import '../features/onboarding/views/panchayat_view.dart';
import '../features/onboarding/views/ward_view.dart';
import '../features/onboarding/views/onboarding_success_view.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/views/phone_view.dart';
import '../features/auth/views/otp_view.dart';
import '../features/auth/views/profile_setup_view.dart';
import '../features/auth/views/notifications_setup_view.dart';
import '../features/shell/bindings/shell_binding.dart';
import '../features/shell/views/main_shell_view.dart';
import '../features/mla/bindings/mla_binding.dart';
import '../features/mla/views/mla_detail_view.dart';
import '../features/report/bindings/report_binding.dart';
import '../features/report/views/report_flow_view.dart';
import '../features/report/views/report_detail_view.dart';
import '../features/appreciation/bindings/appreciation_binding.dart';
import '../features/appreciation/views/appreciation_flow_view.dart';
import '../features/ideas/bindings/idea_binding.dart';
import '../features/ideas/views/idea_flow_view.dart';
import '../features/improvements/bindings/improvement_binding.dart';
import '../features/improvements/views/improvement_flow_view.dart';
import '../features/updates/bindings/updates_binding.dart';
import '../features/updates/views/update_detail_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomeView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.language,
      page: () => const LanguageView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.phone,
      page: () => const PhoneView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.panchayat,
      page: () => const PanchayatView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ward,
      page: () => const WardView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profileSetup,
      page: () => const ProfileSetupView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.notificationsSetup,
      page: () => const NotificationsSetupView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.onboardingSuccess,
      page: () => const OnboardingSuccessView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: () => const MainShellView(),
      binding: ShellBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.mlaDetail,
      page: () => const MlaDetailView(),
      binding: MlaBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.reportFlow,
      page: () => const ReportFlowView(),
      binding: ReportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.reportDetail,
      page: () => const ReportDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.appreciationFlow,
      page: () => const AppreciationFlowView(),
      binding: AppreciationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ideasFlow,
      page: () => const IdeaFlowView(),
      binding: IdeaBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.improvementsFlow,
      page: () => const ImprovementFlowView(),
      binding: ImprovementBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.updateDetail,
      page: () => const UpdateDetailView(),
      binding: UpdatesBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
