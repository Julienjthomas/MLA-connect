import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(AppStrings.selectWard, style: AppTextStyles.headlineSmall),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  'Choose your ward in ${controller.selectedLocalBody.value?.name ?? ''}',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              SizedBox(height: 16.h),

              TextField(
                onChanged: (v) => controller.wardSearch.value = v,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20.r),
                  hintText: AppStrings.searchWard,
                ),
              ),
              SizedBox(height: 16.h),
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
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.ideaPurpleLight : AppColors.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.grey200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20.r,
                                  height: 20.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? AppColors.primary : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.grey400,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected ? Icon(Icons.check, color: Colors.white, size: 12.r) : null,
                                ),
                                SizedBox(width: 12.w),
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
