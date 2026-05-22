import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/app_locale.dart';
import '../../../core/utils/constituency_prefs.dart';
import '../../../core/utils/constituency_db_id.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';
import '../../onboarding/controllers/onboarding_controller.dart';

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
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        _loadUserIfLoggedIn();
      } else if (event.event == AuthChangeEvent.signedOut) {
        _clearLocalSessionContext();
      }
    });
  }

  Future<void> refreshProfile() => _loadUserIfLoggedIn();

  /// Fetches the full citizen profile and populates [user] before any routing
  /// decision is made. Called at splash time so all screens can trust [user]
  /// is already populated. Safe to call when not logged in (no-op).
  Future<void> bootstrapSession() async {
    if (!isLoggedIn) return;
    try {
      final uid = userId;
      if (uid == null) return;
      var profile = await _userService.getProfile(uid);
      if (profile != null && (profile.wardName == null || profile.localBodyName == null)) {
        final wardName = profile.wardName ?? await ConstituencyPrefs.getWardName();
        final localBodyName = profile.localBodyName ?? await ConstituencyPrefs.getLocalBodyName();
        if (wardName != null || localBodyName != null) {
          profile = profile.copyWith(wardName: wardName, localBodyName: localBodyName);
        }
      }
      user.value = profile;
      if (profile != null && !await AppLocale.hasStoredPreference()) {
        AppLocale.change(profile.language);
      }
    } catch (_) {}
  }

  Future<void> _clearLocalSessionContext() async {
    await ConstituencyPrefs.clear();
    if (Get.isRegistered<OnboardingController>()) {
      Get.find<OnboardingController>().clearLocalConstituencyState();
    }
    user.value = null;
  }

  Future<void> _loadUserIfLoggedIn() async {
    final uid = userId;
    if (uid == null) return;
    try {
      var profile = await _userService.getProfile(uid);
      if (profile != null && (profile.wardName == null || profile.localBodyName == null)) {
        final wardName = profile.wardName ?? await ConstituencyPrefs.getWardName();
        final localBodyName = profile.localBodyName ?? await ConstituencyPrefs.getLocalBodyName();
        if (wardName != null || localBodyName != null) {
          profile = profile.copyWith(wardName: wardName, localBodyName: localBodyName);
        }
      }
      user.value = profile;
      if (profile != null && !await AppLocale.hasStoredPreference()) {
        AppLocale.change(profile.language);
      }
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
      if (res.session != null) {
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
    final profile = user.value ?? await _userService.getProfile(uid);
    if (profile == null) return false;
    final nameOk = profile.name.isNotEmpty && profile.name != 'Citizen';
    if (!nameOk) return false;
    if (profile.constituencyId != null && profile.onboardedAt != null) return true;
    // Ward may be a fallback non-numeric ID not stored in DB — check prefs too.
    final wardId = profile.wardId ?? await ConstituencyPrefs.getWardId();
    final constituencyId = profile.constituencyId ?? await ConstituencyPrefs.getId();
    return wardId != null && constituencyId != null;
  }

  /// First incomplete onboarding screen for returning sessions.
  /// Reads SharedPreferences first (written eagerly per step) then falls back
  /// to the loaded user model. Also consumes [ConstituencyPrefs.pendingReturnRoute]
  /// when the user was mid-onboarding and logged out from a specific screen.
  Future<String> resolveOnboardingResumeRoute() async {
    final uid = userId;
    if (uid == null) return Routes.welcome;

    // Check pending return route first (set when user logs out from an onboarding screen).
    final pendingRoute = await ConstituencyPrefs.getPendingReturnRoute();
    if (pendingRoute != null && pendingRoute.isNotEmpty) {
      await ConstituencyPrefs.clearPendingReturnRoute();
      return pendingRoute;
    }

    // Determine resume point from prefs (written eagerly) then user model.
    final wardId = await ConstituencyPrefs.getWardId();
    final localBodyId = await ConstituencyPrefs.getLocalBodyId();
    final constituencyId = await ConstituencyPrefs.getId();

    final profile = user.value ?? await _userService.getProfile(uid);

    // Effective values: prefs take precedence over profile (prefs are written per-step).
    final effectiveConstituencyId = constituencyId ?? profile?.constituencyId;
    final effectiveLocalBodyId = localBodyId ?? profile?.localBodyId;
    final effectiveWardId = wardId ?? profile?.wardId;
    final effectiveName = profile?.name;

    if (effectiveConstituencyId == null) return Routes.constituency;
    if (effectiveLocalBodyId == null) return Routes.panchayat;
    if (effectiveWardId == null) return Routes.ward;
    final nameOk = effectiveName != null && effectiveName.isNotEmpty && effectiveName != 'Citizen';
    if (!nameOk) return Routes.profileSetup;
    // All steps complete — onboarded_at marks notifications were seen.
    if (profile?.onboardedAt != null) return Routes.home;
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

  Future<void> updateBasicProfile(Map<String, dynamic> data) async {
    final uid = userId;
    if (uid == null) return;
    await _userService.updateProfile(uid, data);
    await _loadUserIfLoggedIn();
  }

  Future<void> updateLanguage(String languageCode) async {
    final uid = userId;
    if (uid == null) return;
    await _userService.updateProfile(uid, {'language': languageCode});
    AppLocale.change(languageCode);
    await _loadUserIfLoggedIn();
  }

  /// Signs out the current user. Pass [returnRoute] when logging out from an
  /// onboarding screen so that after re-login the user resumes there.
  Future<void> logout({String? returnRoute}) async {
    if (returnRoute != null) {
      await ConstituencyPrefs.savePendingReturnRoute(returnRoute);
    }
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
    await _clearLocalSessionContext();
    Get.offAllNamed(Routes.welcome);
  }
}
