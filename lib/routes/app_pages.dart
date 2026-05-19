import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/widgets/long_form_composer_view.dart';
import '../features/onboarding/bindings/onboarding_binding.dart';
import '../features/onboarding/bindings/splash_binding.dart';
import '../features/onboarding/views/splash_view.dart';
import '../features/onboarding/views/welcome_view.dart';
import '../features/onboarding/views/constituency_view.dart';
import '../features/onboarding/views/panchayat_view.dart';
import '../features/onboarding/views/ward_view.dart';
import '../features/onboarding/views/onboarding_success_view.dart';
import '../features/auth/bindings/notifications_setup_binding.dart';
import '../features/auth/bindings/otp_binding.dart';
import '../features/auth/bindings/phone_binding.dart';
import '../features/auth/bindings/profile_setup_binding.dart';
import '../features/auth/views/phone_view.dart';
import '../features/auth/views/otp_view.dart';
import '../features/auth/views/profile_setup_view.dart';
import '../features/auth/views/notifications_setup_view.dart';
import '../features/report/bindings/report_binding.dart';
import '../features/report/bindings/report_detail_binding.dart';
import '../features/report/views/report_flow_view.dart';
import '../features/report/views/report_detail_view.dart';
import '../features/shell/bindings/shell_binding.dart';
import '../features/shell/views/main_shell_view.dart';
import '../features/mla/bindings/mla_binding.dart';
import '../features/mla/views/mla_detail_view.dart';
import '../features/appreciation/bindings/appreciation_binding.dart';
import '../features/appreciation/views/appreciation_flow_view.dart';
import '../features/appreciation/views/appreciation_detail_view.dart';
import '../features/ideas/bindings/idea_binding.dart';
import '../features/ideas/views/idea_flow_view.dart';
import '../features/ideas/views/idea_detail_view.dart';
import '../features/improvements/bindings/improvement_binding.dart';
import '../features/improvements/views/improvement_flow_view.dart';
import '../features/improvements/views/improvement_detail_view.dart';
import '../features/achievements/bindings/achievements_binding.dart';
import '../features/achievements/views/achievements_listing_view.dart';
import '../features/achievements/views/add_achievement_view.dart';
import '../features/chat/bindings/chat_binding.dart';
import '../features/chat/views/chat_view.dart';
import '../features/updates/bindings/updates_binding.dart';
import '../features/updates/views/update_detail_view.dart';
import '../features/profile/bindings/profile_edit_binding.dart';
import '../features/profile/views/profile_edit_view.dart';
import '../features/home/views/events_list_view.dart';
import '../features/profile/views/help_faq_view.dart';
import '../features/profile/views/privacy_policy_view.dart';
import '../features/profile/views/contact_mla_office_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomeView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.phone,
      page: () => const PhoneView(),
      binding: PhoneBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: Routes.otp, page: () => const OtpView(), binding: OtpBinding(), transition: Transition.rightToLeft),
    GetPage(
      name: Routes.constituency,
      page: () => const ConstituencyView(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: Routes.panchayat, page: () => const PanchayatView(), binding: OnboardingBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.ward, page: () => const WardView(), binding: OnboardingBinding(), transition: Transition.rightToLeft),
    GetPage(
      name: Routes.profileSetup,
      page: () => const ProfileSetupView(),
      bindings: [OnboardingBinding(), ProfileSetupBinding()],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.notificationsSetup,
      page: () => const NotificationsSetupView(),
      binding: NotificationsSetupBinding(),
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
      name: Routes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
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
      binding: ReportDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.appreciationFlow,
      page: () => const AppreciationFlowView(),
      binding: AppreciationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.appreciationDetail,
      page: () => const AppreciationDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ideasFlow,
      page: () => const IdeaFlowView(),
      binding: IdeaBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ideaDetail,
      page: () => const IdeaDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.improvementsFlow,
      page: () => const ImprovementFlowView(),
      binding: ImprovementBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.improvementDetail,
      page: () => const ImprovementDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.updateDetail,
      page: () => const UpdateDetailView(),
      binding: UpdatesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.achievementsListing,
      page: () => const AchievementsListingView(),
      binding: AchievementsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.addAchievement,
      page: () => const AddAchievementView(),
      binding: AchievementsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profileEdit,
      page: () => const ProfileEditView(),
      binding: ProfileEditBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.eventsList,
      page: () => const EventsListView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.helpFaq,
      page: () => const HelpFaqView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.contactMlaOffice,
      page: () => const ContactMlaOfficeView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.longFormComposer,
      page: () {
        final c = Get.arguments as TextEditingController;
        return LongFormComposerView(textController: c);
      },
      transition: Transition.downToUp,
    ),
  ];
}
