import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_strings.dart';
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
      Get.snackbar(AppStrings.unableToOpen, uri.toString(),
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
        title: Text(AppStrings.contactMlaOffice, style: AppTextStyles.titleMedium),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _mla == null
              ? Center(
                  child: Text(AppStrings.mlaOfficeDetailsUnavailable,
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
                    if (_mla!.contact.phone.isEmpty &&
                        (_mla!.contact.email ?? '').isEmpty &&
                        (_mla!.contact.officeAddress ?? '').isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                size: 32, color: AppColors.grey400),
                            const SizedBox(height: 8),
                            Text(AppStrings.contactDetailsUnavailable,
                                style: AppTextStyles.bodyMedium,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 4),
                            Text(
                                AppStrings.contactDetailsUnavailableMsg,
                                style: AppTextStyles.caption
                                    .copyWith(color: AppColors.textTertiary),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    if (_mla!.contact.phone.isNotEmpty)
                      _entry(
                        icon: Icons.phone_outlined,
                        label: AppStrings.phoneLabel,
                        value: _mla!.contact.phone,
                        onTap: () =>
                            _open(Uri(scheme: 'tel', path: _mla!.contact.phone)),
                      ),
                    if ((_mla!.contact.email ?? '').isNotEmpty)
                      _entry(
                        icon: Icons.mail_outline_rounded,
                        label: AppStrings.emailLabel,
                        value: _mla!.contact.email!,
                        onTap: () => _open(Uri(scheme: 'mailto', path: _mla!.contact.email)),
                      ),
                    if ((_mla!.contact.officeAddress ?? '').isNotEmpty)
                      _entry(
                        icon: Icons.location_on_outlined,
                        label: AppStrings.addressLabel,
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
