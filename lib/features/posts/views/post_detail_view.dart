import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  height: 240.h,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(height: 240.h, color: AppColors.surfaceVariant),
                ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title, style: AppTextStyles.headlineSmall),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14.r, color: AppColors.grey400),
                        SizedBox(width: 4.w),
                        Text(
                          '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(post.body, style: AppTextStyles.bodyMedium),
                    SizedBox(height: 24.h),
                    const Divider(),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Obx(() => GestureDetector(
                          onTap: controller.likePost,
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                size: 22.r,
                                color: controller.liking.value ? AppColors.grey400 : AppColors.statusRejected,
                              ),
                              SizedBox(width: 6.w),
                              Text('${post.likes}', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        )),
                        SizedBox(width: 24.w),
                        Icon(Icons.visibility_outlined, size: 20.r, color: AppColors.grey400),
                        SizedBox(width: 6.w),
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
