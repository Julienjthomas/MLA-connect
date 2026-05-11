import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class PanchayatView extends GetView<OnboardingController> {
  const PanchayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: AppStrings.selectPanchayat, showBack: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepHeader(context),
              const SizedBox(height: 20),
              TextField(
                onChanged: (v) => controller.localBodySearch.value = v,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: AppStrings.searchPanchayat,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.loadingLocalBodies.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = controller.filteredLocalBodies;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      return Obx(() {
                        final p = list[i];
                        final isSelected = controller.selectedLocalBody.value?.id == p.id;
                        return GestureDetector(
                          onTap: () => controller.selectLocalBody(p),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: AppTextStyles.titleMedium),
                                      Text('${p.name} Panchayat', style: AppTextStyles.caption),
                                    ],
                                  ),
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
                  text: AppStrings.next,
                  onPressed: controller.selectedLocalBody.value != null ? () => Get.toNamed(Routes.ward) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepsIndicator(),
        const SizedBox(height: 12),
        Text(AppStrings.selectPanchayat, style: AppTextStyles.headlineSmall),
        const SizedBox(height: 4),
        Text(AppStrings.panchayatHelp, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _stepsIndicator() {
    return Row(
      children: List.generate(5, (i) {
        final isActive = i == 0;
        final isDone = false;
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
            decoration: BoxDecoration(
              color: isActive || isDone ? AppColors.primary : AppColors.grey200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
