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
      final mla = controller.mla.value ?? MlaModel.placeholder;
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
                    CachedNetworkImage(
                      imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800&q=80',
                      fit: BoxFit.cover,
                    ),
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

            // Stats
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat('${mla.stats.issuesResolved}', 'Issues\nResolved', AppColors.reportOrange),
                    _vDivider(),
                    _stat('${mla.stats.activeProjects}', 'Active\nProjects', AppColors.improveBlue),
                    _vDivider(),
                    _stat('${mla.stats.appreciations}', 'Appre-\nciations', AppColors.appreciateGreen),
                    _vDivider(),
                    _stat('${mla.stats.ideasImplemented}', 'Ideas\nDone', AppColors.ideaPurple),
                  ],
                ),
              ),
            ),

            // About MLA — expandable
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _ExpandableAbout(mla: mla),
              ),
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

  Widget _stat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleLarge.copyWith(color: color, fontSize: 22)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption.copyWith(height: 1.2), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _vDivider() => Container(width: 1, height: 40, color: AppColors.grey200);

  void _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _ExpandableAbout extends StatefulWidget {
  final MlaModel mla;
  const _ExpandableAbout({required this.mla});

  @override
  State<_ExpandableAbout> createState() => _ExpandableAboutState();
}

class _ExpandableAboutState extends State<_ExpandableAbout> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final mla = widget.mla;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text('About MLA', style: AppTextStyles.headlineSmall),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey500),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                mla.localBio,
                style: AppTextStyles.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mla.localBio, style: AppTextStyles.bodyMedium),
                  if (mla.education != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.school_outlined, size: 16, color: AppColors.grey500),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(mla.education!, style: AppTextStyles.bodySmall),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
