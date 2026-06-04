import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kerala_app_bar.dart';
import '../../../data/models/post/post_response.dart';
import '../../../routes/app_routes.dart';
import '../controllers/posts_controller.dart';

class PostsFeedView extends GetView<PostsController> {
  const PostsFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KeralaAppBar(title: 'MLA Posts'),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.posts.isEmpty) {
          return const Center(child: Text('No posts yet.', style: AppTextStyles.bodyMedium));
        }
        return RefreshIndicator(
          onRefresh: controller.loadPosts,
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.posts.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, i) => _PostCard(post: controller.posts[i]),
          ),
        );
      }),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final PostResponse post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.postDetail, arguments: {'id': post.id}),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(height: 180.h, color: AppColors.surfaceVariant),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: AppTextStyles.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6.h),
                  Text(
                    post.body,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 16.r, color: AppColors.grey500),
                      SizedBox(width: 4.w),
                      Text('${post.likes}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      SizedBox(width: 16.w),
                      Icon(Icons.visibility_outlined, size: 16.r, color: AppColors.grey500),
                      SizedBox(width: 4.w),
                      Text('${post.views}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      const Spacer(),
                      Text(
                        _timeAgo(post.createdAt),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${dt.day}/${dt.month}/${dt.year}';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
