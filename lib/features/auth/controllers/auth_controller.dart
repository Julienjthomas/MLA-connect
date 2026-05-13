import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/app_locale.dart';
import '../../../core/utils/constituency_prefs.dart';
import '../../../core/utils/constituency_db_id.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final _userService = UserService();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => Supabase.instance.client.auth.currentSession != null;

  String? get userId => Supabase.instance.client.auth.currentUser?.id;

  /// For `submissions.reporter_id`: [UserModel.citizenRowId] when the column references `citizens.id` (bigint), otherwise auth UUID (legacy `profiles` FK).
  String? get submissionReporterId => user.value?.citizenRowId ?? userId;

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

  Future<void> refreshProfile() => _loadUserIfLoggedIn();

  Future<void> _loadUserIfLoggedIn() async {
    final uid = userId;
    if (uid == null) return;
    try {
      await _syncConstituencyFromPrefsIfNeeded();
      final profile = await _userService.getProfile(uid);
      user.value = profile;
      if (profile != null) AppLocale.change(profile.language);
    } catch (_) {}
  }

  Future<void> _syncConstituencyFromPrefsIfNeeded() async {
    final uid = userId;
    if (uid == null) return;
    final profile = await _userService.getProfile(uid);
    if (profile?.constituencyId != null) return;
    final prefsId = await ConstituencyPrefs.getId();
    if (prefsId == null) return;
    await _userService.saveConstituencySelection(userId: uid, constituencyId: prefsId);
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
      if (res.session != null) {
        await _syncConstituencyFromPrefsIfNeeded();
        await _loadUserIfLoggedIn();
      }
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
    if (profile == null) return false;
    final nameOk = profile.name.isNotEmpty && profile.name != 'Citizen';
    if (nameOk &&
        profile.constituencyId != null &&
        profile.onboardedAt != null) {
      return true;
    }
    return nameOk && profile.wardId != null && profile.constituencyId != null;
  }

  /// First incomplete onboarding screen for returning sessions.
  Future<String> resolveOnboardingResumeRoute() async {
    final uid = userId;
    if (uid == null) return Routes.welcome;
    final profile = await _userService.getProfile(uid);
    if (profile == null) return Routes.constituency;
    if (profile.constituencyId == null) return Routes.constituency;
    final nameOk = profile.name.isNotEmpty && profile.name != 'Citizen';
    if (profile.onboardedAt != null && nameOk) {
      return Routes.notificationsSetup;
    }
    if (profile.localBodyId == null) return Routes.panchayat;
    if (profile.wardId == null) return Routes.ward;
    if (profile.name.isEmpty || profile.name == 'Citizen') return Routes.profileSetup;
    return Routes.notificationsSetup;
  }

  Future<void> saveProfile({
    required String name,
    String? email,
    String? avatarUrl,
    required String? constituencyId,
    required String localBodyId,
    required String wardId,
    required String language,
  }) async {
    final uid = userId;
    if (uid == null) return;
    final phone = Supabase.instance.client.auth.currentUser?.phone ?? '';
    String? resolvedConstituencyId = constituencyId;
    if (constituencyId != null) {
      resolvedConstituencyId =
          await ConstituencyDbId.resolve(Supabase.instance.client, constituencyId) ?? constituencyId;
    }
    final persistLocalBody = ConstituencyDbId.isNumericId(localBodyId);
    final persistWard = ConstituencyDbId.isNumericId(wardId);
    if (kDebugMode && (!persistLocalBody || !persistWard)) {
      debugPrint(
        '[AuthController] saveProfile: skipping non-numeric local_body_id/ward_id '
        '(DB has no rows for this geography yet).',
      );
    }
    final data = {
      'user_id': uid,
      'full_name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (resolvedConstituencyId != null && ConstituencyDbId.isNumericId(resolvedConstituencyId))
        'constituency_id': resolvedConstituencyId,
      if (persistLocalBody) 'local_body_id': localBodyId,
      if (persistWard) 'ward_id': wardId,
      'language': language,
      'onboarded_at': DateTime.now().toIso8601String(),
    };
    await _userService.createProfile(data);
    await _loadUserIfLoggedIn();
  }

  Future<void> updateLanguage(String languageCode) async {
    final uid = userId;
    if (uid == null) return;
    await _userService.updateProfile(uid, {'language': languageCode});
    AppLocale.change(languageCode);
    await _loadUserIfLoggedIn();
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
    user.value = null;
    Get.offAllNamed(Routes.welcome);
  }
}
