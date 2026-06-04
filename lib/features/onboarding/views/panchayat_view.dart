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

class PanchayatView extends GetView<OnboardingController> {
  const PanchayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KeralaAppBar(title: AppStrings.selectPanchayat, showBack: false),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepHeader(context),
              SizedBox(height: 20.h),
              TextField(
                onChanged: (v) => controller.localBodySearch.value = v,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20.r),
                  hintText: AppStrings.searchPanchayat,
                ),
              ),
              SizedBox(height: 16.h),
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
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
        SizedBox(height: 12.h),
        Text(AppStrings.selectPanchayat, style: AppTextStyles.headlineSmall),
        SizedBox(height: 4.h),
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
            height: 3.h,
            margin: EdgeInsets.only(right: i < 4 ? 4.w : 0),
            decoration: BoxDecoration(
              color: isActive || isDone ? AppColors.primary : AppColors.grey200,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}
