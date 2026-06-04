import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/appreciation_controller.dart';

class _AppreciationCategory {
  final String key;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  const _AppreciationCategory({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const _categories = [
  _AppreciationCategory(
    key: 'public_works',
    label: 'Public Works',
    description: 'Roads, drainage, streetlights, water supply, cleanliness, etc.',
    icon: Icons.landscape_rounded,
    color: Color(0xFF4CAF50),
  ),
  _AppreciationCategory(
    key: 'quick_response',
    label: 'Quick Response',
    description: 'Fast action taken on an issue or complaint.',
    icon: Icons.bolt_rounded,
    color: Color(0xFFFFC107),
  ),
  _AppreciationCategory(
    key: 'helpful_support',
    label: 'Helpful Support',
    description: 'Friendly, respectful, or supportive interaction from the team.',
    icon: Icons.handshake_rounded,
    color: Color(0xFF26A69A),
  ),
  _AppreciationCategory(
    key: 'community_initiative',
    label: 'Community Initiative',
    description: 'Events, awareness programs, welfare activities, or local development.',
    icon: Icons.campaign_rounded,
    color: Color(0xFF7E57C2),
  ),
  _AppreciationCategory(
    key: 'good_leadership',
    label: 'Good Leadership',
    description: 'Transparency, communication, or effective leadership.',
    icon: Icons.person_rounded,
    color: Color(0xFF42A5F5),
  ),
  _AppreciationCategory(
    key: 'other',
    label: 'Other',
    description: 'Something else worth appreciating.',
    icon: Icons.favorite_rounded,
    color: Color(0xFFEF5350),
  ),
];

class RecipientStep extends GetView<AppreciationController> {
  const RecipientStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appreciateWhoHeading, style: AppTextStyles.headlineSmall),
          SizedBox(height: 6.h),
          Text(
            AppStrings.appreciateWhoSubtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
          SizedBox(height: 20.h),
          Obx(() {
            final selected = controller.recipientCategory.value;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.15,
              children: _categories.map((cat) {
                final isSelected = selected == cat.key;
                return GestureDetector(
                  onTap: () => controller.recipientCategory.value = cat.key,
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isSelected ? cat.color.withValues(alpha: 0.08) : AppColors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isSelected ? cat.color : AppColors.grey200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(cat.icon, size: 18.r, color: cat.color),
                            ),
                            SizedBox(height: 8.h),
                            Text(cat.label, style: AppTextStyles.titleSmall.copyWith(fontSize: 13.sp)),
                            SizedBox(height: 2.h),
                            Expanded(
                              child: Text(
                                cat.description,
                                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 11.sp),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 18.r,
                            height: 18.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? cat.color : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? cat.color : AppColors.grey400,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Icon(Icons.check, color: Colors.white, size: 11.r)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          SizedBox(height: 20.h),
          Text(AppStrings.appreciateTellUsMore, style: AppTextStyles.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.messageController,
            maxLines: 4,
            maxLength: 1500,
            decoration: InputDecoration(hintText: AppStrings.appreciateTellUsMoreHint),
          ),
          SizedBox(height: 32.h),
          PrimaryButton(
            text: AppStrings.continueBtn,
            onPressed: controller.nextStep,
            backgroundColor: AppColors.appreciateGreen,
            icon: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18.r),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
