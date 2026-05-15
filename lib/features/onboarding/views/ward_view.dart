import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class WardView extends GetView<OnboardingController> {
  const WardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KeralaAppBar(title: AppStrings.selectWard),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(AppStrings.selectWard, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  'Choose your ward in ${controller.selectedLocalBody.value?.name ?? ''}',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                onChanged: (v) => controller.wardSearch.value = v,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: AppStrings.searchWard,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.loadingWards.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = controller.filteredWards;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final w = list[i];
                      return Obx(() {
                        final isSelected = controller.selectedWard.value?.id == w.id;
                        return GestureDetector(
                          onTap: () => controller.selectWard(w),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                Text(w.displayName, style: AppTextStyles.titleSmall),
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
                  text: AppStrings.next,
                  onPressed: controller.selectedWard.value != null ? () => Get.toNamed(Routes.profileSetup) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
