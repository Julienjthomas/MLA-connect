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
              SizedBox(height: 16),
              ShimmerBox(height: 160, borderRadius: 14),
            ]),
          ),
        );
      }
      final mla = controller.mla.value ?? MlaModel.placeholder;
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            // Collapsing hero
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
                      bottom: 16,
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
                              errorWidget: (_, __, ___) => Container(color: Colors.white24, child: const Icon(Icons.person, color: Colors.white, size: 40)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(mla.name, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded, color: Colors.white70, size: 16),
                            ]),
                            Text(mla.constituency, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: Text(mla.term, style: AppTextStyles.caption.copyWith(color: Colors.white)),
                            ),
                          ],
                        )),
                      ]),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {}),
              ],
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

            // About
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About MLA', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    Text(mla.bio, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    TextButton(onPressed: () {}, child: const Text('View More')),
                  ],
                ),
              ),
            ),

            // Initiatives
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Constituency Initiatives', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    ...mla.initiatives.map((init) => _InitiativeCard(initiative: init)),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _call(mla.contact.phone),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Call Office'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.appreciateGreen, minimumSize: const Size(0, 48)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _whatsapp(mla.contact.whatsapp ?? mla.contact.phone),
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), minimumSize: const Size(0, 48)),
                ),
              ),
            ]),
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

  void _whatsapp(String phone) async {
    final number = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _InitiativeCard extends StatelessWidget {
  final MlaInitiative initiative;
  const _InitiativeCard({required this.initiative});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.grey200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (initiative.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: CachedNetworkImage(
                imageUrl: initiative.imageUrl!,
                height: 120, width: double.infinity, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(height: 120, color: AppColors.grey200),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(initiative.title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 4),
              Text(initiative.description, style: AppTextStyles.bodySmall),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: initiative.progress,
                    backgroundColor: AppColors.grey200,
                    valueColor: const AlwaysStoppedAnimation(AppColors.appreciateGreen),
                    minHeight: 6,
                  ),
                )),
                const SizedBox(width: 10),
                Text('${(initiative.progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(color: AppColors.appreciateGreen)),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}
