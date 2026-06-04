import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_locale.dart';
import '../../../core/utils/constituency_prefs.dart';
import '../../../data/models/auth/auth_response.dart';
import '../../../data/models/auth/otp_send_request.dart';
import '../../../data/models/auth/otp_verify_request.dart';
import '../../../data/models/user_model.dart';
import '../../../data/remote/auth_api.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';
import '../../onboarding/controllers/onboarding_controller.dart';

class AuthController extends GetxController {
  final _userService = UserService();
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _citizenIdKey = 'citizen_id';
  static const _refreshTokenKey = 'refresh_token';

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  String? _cachedCitizenId;

  String? get userId => _cachedCitizenId;

  /// For `submissions.reporter_id` — citizenId from JWT session.
  String? get submissionReporterId => _cachedCitizenId;

  AuthApi get _authApi => Get.find<AuthApi>();

  @override
  void onInit() {
    super.onInit();
    _initSessionState();
  }

  Future<void> _initSessionState() async {
    final token = await _storage.read(key: _tokenKey);
    _cachedCitizenId = await _storage.read(key: _citizenIdKey);
    _isLoggedIn.value = token != null && token.isNotEmpty;
  }

  Future<void> refreshProfile() => _loadUserIfLoggedIn();

  /// Checks JWT presence and loads citizen profile before routing at splash.
  Future<void> bootstrapSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) return;
    _cachedCitizenId = await _storage.read(key: _citizenIdKey);
    _isLoggedIn.value = true;
    try {
      await _loadUserIfLoggedIn();
    } catch (_) {}
  }

  Future<void> _clearLocalSessionContext() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _citizenIdKey);
    await _storage.delete(key: _refreshTokenKey);
    _cachedCitizenId = null;
    _isLoggedIn.value = false;
    await ConstituencyPrefs.clear();
    if (Get.isRegistered<OnboardingController>()) {
      Get.find<OnboardingController>().clearLocalConstituencyState();
    }
    user.value = null;
  }

  Future<void> _loadUserIfLoggedIn() async {
    final citizenId = _cachedCitizenId;
    if (citizenId == null) return;
    try {
      var profile = await _userService.getProfile(citizenId);
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
    await _authApi.sendOtp(OtpSendRequest(phone: normalized));
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    final normalized = _normalizePhone(phone);
    debugPrint('[Auth] verifyOtp → $normalized');
    try {
      final AuthResponse response = await _authApi.verifyOtp(
        OtpVerifyRequest(phone: normalized, otp: otp),
      );
      await _storage.write(key: _tokenKey, value: response.token);
      await _storage.write(key: _citizenIdKey, value: response.citizenId);
      if (response.refreshToken != null) {
        await _storage.write(key: _refreshTokenKey, value: response.refreshToken!);
      }
      _cachedCitizenId = response.citizenId;
      _isLoggedIn.value = true;
      debugPrint('[Auth] verifyOtp success → citizenId=${response.citizenId}');
      return true;
    } catch (e) {
      debugPrint('[Auth] verifyOtp error → $e');
      return false;
    }
  }

  Future<bool> hasCompletedOnboarding() async {
    final citizenId = _cachedCitizenId;
    if (citizenId == null) return false;
    final profile = user.value;
    if (profile == null) return false;
    final nameOk = profile.name.isNotEmpty && profile.name != 'Citizen';
    if (!nameOk) return false;
    if (profile.constituencyId != null && profile.onboardedAt != null) return true;
    final wardId = profile.wardId ?? await ConstituencyPrefs.getWardId();
    final constituencyId = profile.constituencyId ?? await ConstituencyPrefs.getId();
    return wardId != null && constituencyId != null;
  }

  Future<String> resolveOnboardingResumeRoute() async {
    if (_cachedCitizenId == null) return Routes.welcome;

    final pendingRoute = await ConstituencyPrefs.getPendingReturnRoute();
    if (pendingRoute != null && pendingRoute.isNotEmpty) {
      await ConstituencyPrefs.clearPendingReturnRoute();
      return pendingRoute;
    }

    final wardId = await ConstituencyPrefs.getWardId();
    final localBodyId = await ConstituencyPrefs.getLocalBodyId();
    final constituencyId = await ConstituencyPrefs.getId();
    final profile = user.value;

    final effectiveConstituencyId = constituencyId ?? profile?.constituencyId;
    final effectiveLocalBodyId = localBodyId ?? profile?.localBodyId;
    final effectiveWardId = wardId ?? profile?.wardId;
    final effectiveName = profile?.name;

    if (effectiveConstituencyId == null) return Routes.constituency;
    if (effectiveLocalBodyId == null) return Routes.panchayat;
    if (effectiveWardId == null) return Routes.ward;
    final nameOk = effectiveName != null && effectiveName.isNotEmpty && effectiveName != 'Citizen';
    if (!nameOk) return Routes.profileSetup;
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
    final citizenId = _cachedCitizenId;
    if (citizenId == null) return;
    final data = {
      'full_name': name,
      if (email != null && email.isNotEmpty) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (constituencyId != null) 'constituency_id': constituencyId,
      'local_body_id': localBodyId,
      'ward_id': wardId,
      'language': language,
      'onboarded_at': DateTime.now().toIso8601String(),
    };
    await _userService.createProfile(data);
    await _loadUserIfLoggedIn();
  }

  Future<void> updateBasicProfile(Map<String, dynamic> data) async {
    final citizenId = _cachedCitizenId;
    if (citizenId == null) return;
    await _userService.updateProfile(citizenId, data);
    await _loadUserIfLoggedIn();
  }

  Future<void> updateLanguage(String languageCode) async {
    final citizenId = _cachedCitizenId;
    if (citizenId == null) return;
    await _userService.updateProfile(citizenId, {'language': languageCode});
    AppLocale.change(languageCode);
    await _loadUserIfLoggedIn();
  }

  void incrementContributionCount() {
    final current = user.value;
    if (current != null) {
      user.value = current.copyWith(contributionCount: current.contributionCount + 1);
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final dio = Get.find();
      await dio.delete('/citizens/:citizenId/account');
      await _clearLocalSessionContext();
      Get.offAllNamed(Routes.welcome);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout({String? returnRoute}) async {
    if (returnRoute != null) {
      await ConstituencyPrefs.savePendingReturnRoute(returnRoute);
    }
    // Best-effort REST logout — ignore failure.
    try {
      final dio = Get.find();
      await dio.post('/citizens/:citizenId/auth/logout');
    } catch (_) {}
    await _clearLocalSessionContext();
    Get.offAllNamed(Routes.welcome);
  }
}
