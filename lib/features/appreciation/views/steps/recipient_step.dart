import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/appreciation_controller.dart';

class RecipientStep extends GetView<AppreciationController> {
  const RecipientStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Who are you appreciating?', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 6),
          Text('Choose your MLA or a direct staff member.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 20),
          Text('Recipient *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.loadingRecipients.value && controller.recipients.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.recipients.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('No recipients available yet.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
              );
            }
            return Column(
              children: controller.recipients.map((r) {
                final isSelected = controller.selectedRecipient.value?.id == r.id &&
                    controller.selectedRecipient.value?.type == r.type;
                return GestureDetector(
                  onTap: () => controller.selectedRecipient.value = r,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.appreciateGreenLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSelected ? AppColors.appreciateGreen : AppColors.grey200,
                          width: isSelected ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        _avatar(r.photoUrl, r.name),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: AppTextStyles.titleSmall),
                              if ((r.designation ?? '').isNotEmpty)
                                Text(r.designation!,
                                    style: AppTextStyles.caption
                                        .copyWith(color: AppColors.textTertiary)),
                            ],
                          ),
                        ),
                        if (r.type == 'mla')
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.appreciateGreen.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('MLA',
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: AppColors.appreciateGreen)),
                          ),
                        const SizedBox(width: 6),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.appreciateGreen : Colors.transparent,
                            border: Border.all(
                                color: isSelected
                                    ? AppColors.appreciateGreen
                                    : AppColors.grey400,
                                width: 2),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 12)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 14),
          Text('Related Work / Project (Optional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TextField(
              controller: controller.relatedWorkController,
              decoration: const InputDecoration(
                  hintText: 'e.g. Road repair at Kuttikattoor')),
          const SizedBox(height: 32),
          PrimaryButton(
              text: 'Next: Your Message →',
              onPressed: controller.nextStep,
              backgroundColor: AppColors.appreciateGreen),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _avatar(String? url, String name) {
    final initial = name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.appreciateGreenLight,
      ),
      clipBehavior: Clip.antiAlias,
      child: (url != null && url.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _initial(initial),
            )
          : _initial(initial),
    );
  }

  Widget _initial(String s) => Center(
        child: Text(s,
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.appreciateGreen)),
      );
}
