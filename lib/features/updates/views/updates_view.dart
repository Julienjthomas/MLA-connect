import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../routes/app_routes.dart';
import '../controllers/updates_controller.dart';

class UpdatesView extends GetView<UpdatesController> {
  const UpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.updates, style: AppTextStyles.titleLarge),
            Text(AppStrings.stayUpdated, style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 52,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  children: UpdateCategory.values.map((cat) {
                    final isSelected = controller.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => controller.selectCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.grey300),
                        ),
                        child: Text(
                          cat.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
          ),
          // Feed
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return ListView.builder(padding: const EdgeInsets.all(16), itemCount: 3, itemBuilder: (_, __) => const ShimmerCard());
              }
              final items = controller.filteredUpdates;
              if (items.isEmpty) {
                return const EmptyState(title: 'No updates', message: 'No updates for this category yet.');
              }
              return RefreshIndicator(
                onRefresh: controller.loadUpdates,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _UpdateCard(update: items[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _UpdateCard extends StatelessWidget {
  final dynamic update;
  const _UpdateCard({required this.update});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.updateDetail, arguments: update.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (update.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: update.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(height: 180, color: AppColors.grey200),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(label: update.category.label, color: update.category.color),
                  const SizedBox(height: 8),
                  Text(update.title, style: AppTextStyles.titleLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(update.shortBody, style: AppTextStyles.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text(update.timeAgo, style: AppTextStyles.caption),
                    const Spacer(),
                    const Icon(Icons.visibility_outlined, size: 14, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text('${update.views}', style: AppTextStyles.caption),
                    const SizedBox(width: 12),
                    const Icon(Icons.favorite_outline, size: 14, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text('${update.likes}', style: AppTextStyles.caption),
                    const SizedBox(width: 12),
                    const Icon(Icons.share_outlined, size: 14, color: AppColors.grey500),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
