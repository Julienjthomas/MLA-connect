import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../data/models/mla_model.dart';
import '../controllers/mla_controller.dart';

class MlaDetailView extends GetView<MlaController> {
  const MlaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              ShimmerBox(height: 240),
              SizedBox(height: 16),
              ShimmerBox(height: 80, borderRadius: 16),
              SizedBox(height: 16),
              ShimmerBox(height: 120, borderRadius: 16),
            ]),
          ),
        );
      }
      final mla = controller.mla.value;
      if (mla == null) {
        return const Scaffold(
          body: Center(child: Text('MLA data unavailable')),
        );
      }
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if ((mla.coverImageUrl ?? '').isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: mla.coverImageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(color: AppColors.primaryDark),
                      )
                    else
                      Container(color: AppColors.primaryDark),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppColors.primaryDark],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: mla.photoUrl ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: Colors.white24,
                                child: const Icon(Icons.person, color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'MLA',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white60,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(mla.name, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                            Text(mla.constituency, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                          ],
                        )),
                      ]),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // About MLA — expandable
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _ExpandableAbout(mla: mla),
              ),
            ),

            // Photo gallery — hidden when empty.
            if (mla.galleryUrls.isNotEmpty)
              SliverToBoxAdapter(
                child: _PhotoGallery(urls: mla.galleryUrls),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mla.contact.officeAddress != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey500),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          mla.contact.officeAddress!,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _call(mla.contact.phone),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call Office'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appreciateGreen,
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _ExpandableAbout extends StatelessWidget {
  final MlaModel mla;
  const _ExpandableAbout({required this.mla});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('About MLA', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Text(_aboutText(mla), style: AppTextStyles.bodyMedium),
            if (mla.education != null) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school_outlined, size: 16, color: AppColors.grey500),
                  const SizedBox(width: 6),
                  Expanded(child: Text(mla.education!, style: AppTextStyles.bodySmall)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _aboutText(MlaModel mla) {
  final bio = mla.localBio.trim();
  if (bio.isNotEmpty) return bio;
  final constituency = mla.constituency.trim();
  if (constituency.isNotEmpty) {
    return 'Serving the people of $constituency. More about the MLA will be added soon.';
  }
  return 'More about the MLA will be added soon.';
}

class _PhotoGallery extends StatelessWidget {
  final List<String> urls;
  const _PhotoGallery({required this.urls});

  void _openViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _GalleryViewer(urls: urls, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Gallery', style: AppTextStyles.headlineSmall),
          ),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: urls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () => _openViewer(context, i),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: urls[i],
                      width: 140,
                      height: 110,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 140,
                        height: 110,
                        color: AppColors.grey200,
                        child: const Icon(Icons.broken_image_outlined, color: AppColors.grey400),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryViewer extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  const _GalleryViewer({required this.urls, required this.initialIndex});

  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late final PageController _pc = PageController(initialPage: widget.initialIndex);

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pc,
        itemCount: widget.urls.length,
        itemBuilder: (_, i) => InteractiveViewer(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.urls[i],
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
            ),
          ),
        ),
      ),
    );
  }
}
