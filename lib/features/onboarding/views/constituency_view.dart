import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/services/user_service.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';

class ConstituencyView extends GetView<OnboardingController> {
  const ConstituencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KeralaAppBar(title: 'Assembly constituency', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select your constituency', style: AppTextStyles.headlineSmall),
              SizedBox(height: 4.h),
              Text(
                'You can change detailed location (panchayath / ward) in the next steps.',
                style: AppTextStyles.bodySmall,
              ),
              SizedBox(height: 20.h),
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
                          final uid = Get.find<AuthController>().userId;
                          if (uid != null) {
                            await UserService().saveConstituencySelection(
                              userId: uid,
                              constituencyId: c.id,
                            );
                            await Get.find<AuthController>().refreshProfile();
                          }
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
