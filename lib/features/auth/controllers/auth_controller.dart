import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/app_locale.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final _userService = UserService();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => Supabase.instance.client.auth.currentSession != null;

  String? get userId => Supabase.instance.client.auth.currentUser?.id;

  @override
  void onInit() {
    super.onInit();
    _loadUserIfLoggedIn();
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        _loadUserIfLoggedIn();
      } else if (event.event == AuthChangeEvent.signedOut) {
        user.value = null;
      }
    });
  }

  Future<void> _loadUserIfLoggedIn() async {
    final uid = userId;
    if (uid == null) return;
    try {
      final profile = await _userService.getProfile(uid);
      user.value = profile;
      if (profile != null) AppLocale.change(profile.language);
    } catch (_) {}
  }

  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('91') && digits.length == 12) return '+$digits';
    return '+91$digits';
  }

  Future<void> sendOtp(String phone) async {
    final normalized = _normalizePhone(phone);
    debugPrint('[Auth] sendOtp → $normalized');
    await Supabase.instance.client.auth.signInWithOtp(phone: normalized);
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    final normalized = _normalizePhone(phone);
    debugPrint('[Auth] verifyOtp → $normalized, token=$otp');
    try {
      final res = await Supabase.instance.client.auth.verifyOTP(
        phone: normalized,
        token: otp,
        type: OtpType.sms,
      );
      debugPrint('[Auth] verifyOtp result → session=${res.session?.accessToken != null}');
      return res.session != null;
    } catch (e) {
      debugPrint('[Auth] verifyOtp error → $e');
      return false;
    }
  }

  Future<bool> hasCompletedOnboarding() async {
    final uid = userId;
    if (uid == null) return false;
    final profile = await _userService.getProfile(uid);
    return profile != null && profile.name.isNotEmpty && profile.wardId != null;
  }

  Future<void> saveProfile({
    required String name,
    String? email,
    String? avatarUrl,
    required String localBodyId,
    required String wardId,
    required String language,
  }) async {
    final uid = userId;
    if (uid == null) return;
    final phone = Supabase.instance.client.auth.currentUser?.phone ?? '';
    final data = {
      'user_id': uid,
      'full_name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'local_body_id': localBodyId,
      'ward_id': wardId,
      'language': language,
      'onboarded_at': DateTime.now().toIso8601String(),
    };
    await _userService.createProfile(data);
    await _loadUserIfLoggedIn();
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    user.value = null;
    Get.offAllNamed(Routes.welcome);
  }
}
