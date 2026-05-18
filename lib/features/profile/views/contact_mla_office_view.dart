import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mla_model.dart';
import '../../../data/services/mla_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ContactMlaOfficeView extends StatefulWidget {
  const ContactMlaOfficeView({super.key});

  @override
  State<ContactMlaOfficeView> createState() => _ContactMlaOfficeViewState();
}

class _ContactMlaOfficeViewState extends State<ContactMlaOfficeView> {
  final _service = MlaService();
  MlaModel? _mla;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cid = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>().user.value?.constituencyId
        : null;
    final mla = await _service.getMlaProfile(constituencyId: cid);
    if (!mounted) return;
    setState(() {
      _mla = mla;
      _loading = false;
    });
  }

  Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Unable to open', uri.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Contact MLA Office', style: AppTextStyles.titleMedium),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _mla == null
              ? Center(
                  child: Text('MLA office details unavailable.',
                      style: AppTextStyles.bodyMedium))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_mla!.name, style: AppTextStyles.titleMedium),
                          if (_mla!.constituency.isNotEmpty)
                            Text(_mla!.constituency,
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_mla!.contact.phone.isNotEmpty)
                      _entry(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: _mla!.contact.phone,
                        onTap: () =>
                            _open(Uri(scheme: 'tel', path: _mla!.contact.phone)),
                      ),
                    if ((_mla!.contact.email ?? '').isNotEmpty)
                      _entry(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value: _mla!.contact.email!,
                        onTap: () => _open(Uri(scheme: 'mailto', path: _mla!.contact.email)),
                      ),
                    if ((_mla!.contact.officeAddress ?? '').isNotEmpty)
                      _entry(
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        value: _mla!.contact.officeAddress!,
                        onTap: () => _open(Uri(
                            scheme: 'https',
                            host: 'www.google.com',
                            path: '/maps/search/',
                            queryParameters: {'api': '1', 'query': _mla!.contact.officeAddress!})),
                      ),
                  ],
                ),
    );
  }

  Widget _entry({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: AppTextStyles.caption),
        subtitle: Text(value, style: AppTextStyles.titleSmall),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
