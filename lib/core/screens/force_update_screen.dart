import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  static const _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.mlaconnect.app';
  static const _appStoreUrl = 'https://apps.apple.com/app/mla-connect/id000000000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: const BoxDecoration(
                  color: AppColors.ideaPurpleLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.system_update_rounded, size: 52.r, color: AppColors.primary),
              ),
              SizedBox(height: 32.h),
              const Text(
                'Time for an Update',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'A newer version of MLA Connect is available. Please update to continue using the app.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: const Text('Update Now', style: AppTextStyles.titleSmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStore() async {
    final url = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
