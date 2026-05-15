import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/constants/constituency_seed.dart';
import '../../../core/services/app_icon_service.dart';
import '../../../core/utils/constituency_prefs.dart';
import '../../../data/services/user_service.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class ConstituencyView extends GetView<OnboardingController> {
  const ConstituencyView({super.key});

  bool get _isPreAuth {
    final args = Get.arguments;
    if (args is bool) return args;
    if (args is Map) return args['preAuth'] == true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: 'Assembly constituency', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select your constituency', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'You can change detailed location (panchayath / ward) in the next steps.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.loadingConstituencies.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = controller.constituencies;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final c = list[i];
                      return Obx(() {
                        final isSelected = controller.selectedConstituency.value?.id == c.id;
                        return GestureDetector(
                          onTap: () => controller.selectConstituency(c),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.ideaPurpleLight : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.grey200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? AppColors.primary : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.grey400,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(c.name, style: AppTextStyles.titleMedium),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
              Obx(
                () => PrimaryButton(
                  text: 'Next',
                  onPressed: controller.selectedConstituency.value != null
                      ? () async {
                          final c = controller.selectedConstituency.value!;
                          final slug = c.slug ?? ConstituencySeed.slugForConstituencyName(c.name);
                          if (_isPreAuth) {
                            await ConstituencyPrefs.save(id: c.id, name: c.name);
                            await AppIconService.setForConstituency(slug);
                            Get.toNamed(Routes.phone);
                            return;
                          }
                          final uid = Get.find<AuthController>().userId;
                          if (uid != null) {
                            await UserService().saveConstituencySelection(
                              userId: uid,
                              constituencyId: c.id,
                            );
                            await Get.find<AuthController>().refreshProfile();
                          }
                          await AppIconService.setForConstituency(slug);
                          Get.toNamed(Routes.panchayat);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
