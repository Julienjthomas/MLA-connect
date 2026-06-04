import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../controllers/posts_controller.dart';

class PostDetailView extends GetView<PostsController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(title: 'Post'),
      body: Obx(() {
        if (controller.loadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final post = controller.selectedPost.value;
        if (post == null) return const Center(child: Text('Post not found.'));
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(height: 240, color: AppColors.surfaceVariant),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title, style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey400),
                        const SizedBox(width: 4),
                        Text(
                          '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(post.body, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Obx(() => GestureDetector(
                          onTap: controller.likePost,
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                size: 22,
                                color: controller.liking.value ? AppColors.grey400 : AppColors.statusRejected,
                              ),
                              const SizedBox(width: 6),
                              Text('${post.likes}', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        )),
                        const SizedBox(width: 24),
                        const Icon(Icons.visibility_outlined, size: 20, color: AppColors.grey400),
                        const SizedBox(width: 6),
                        Text('${post.views}', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
