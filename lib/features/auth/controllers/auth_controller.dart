import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<void> sendOtp(String phone) async {
    await Supabase.instance.client.auth.signInWithOtp(phone: '+91$phone');
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final res = await Supabase.instance.client.auth.verifyOTP(phone: '+91$phone', token: otp, type: OtpType.sms);
      return res.session != null;
    } catch (_) {
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
    required String panchayatId,
    required String wardId,
    required String language,
  }) async {
    final uid = userId;
    if (uid == null) return;
    final phone = Supabase.instance.client.auth.currentUser?.phone ?? '';
    final data = {
      'id': uid,
      'name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'panchayat_id': panchayatId,
      'ward_id': wardId,
      'language': language,
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
