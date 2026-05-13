import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/constituency_db_id.dart';
import '../../../core/utils/constituency_prefs.dart';
import '../../../data/models/constituency_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../auth/controllers/auth_controller.dart';

class OnboardingController extends GetxController {
  final _userService = UserService();

  final RxList<ConstituencyModel> constituencies = <ConstituencyModel>[].obs;
  final Rx<ConstituencyModel?> selectedConstituency = Rx(null);

  final RxList<LocalBodyModel> localBodies = <LocalBodyModel>[].obs;
  final RxList<WardModel> wards = <WardModel>[].obs;
  final Rx<LocalBodyModel?> selectedLocalBody = Rx(null);
  final Rx<WardModel?> selectedWard = Rx(null);
  final RxBool loadingConstituencies = false.obs;
  final RxBool loadingLocalBodies = false.obs;
  final RxBool loadingWards = false.obs;
  final RxString localBodySearch = ''.obs;
  final RxString wardSearch = ''.obs;

  List<LocalBodyModel> get filteredLocalBodies =>
      localBodies.where((p) => p.name.toLowerCase().contains(localBodySearch.value.toLowerCase())).toList();

  List<WardModel> get filteredWards =>
      wards.where((w) => w.displayName.toLowerCase().contains(wardSearch.value.toLowerCase())).toList();

  @override
  void onInit() {
    super.onInit();
    loadConstituencies();
  }

  Future<void> loadConstituencies() async {
    loadingConstituencies.value = true;
    try {
      constituencies.value = await _userService.getConstituencies();
    } catch (_) {
      constituencies.value = [];
    } finally {
      loadingConstituencies.value = false;
    }
  }

  Future<void> selectConstituency(ConstituencyModel c) async {
    selectedConstituency.value = c;
    selectedLocalBody.value = null;
    selectedWard.value = null;
    localBodies.clear();
    wards.clear();
    loadingLocalBodies.value = true;
    try {
      localBodies.value = await _userService.getLocalBodies(constituencyId: c.id);
    } catch (_) {
      localBodies.value = [];
    } finally {
      loadingLocalBodies.value = false;
    }
  }

  Future<void> selectLocalBody(LocalBodyModel lb) async {
    selectedLocalBody.value = lb;
    selectedWard.value = null;
    wards.clear();
    loadingWards.value = true;
    try {
      wards.value = await _userService.getWards(
        lb.id,
        constituencyId: selectedConstituency.value?.id,
        localBodyName: lb.name,
      );
    } catch (_) {
      wards.value = [];
    } finally {
      loadingWards.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _hydrateFromSavedProfile();
    _hydrateFromPrefs();
  }

  Future<void> _hydrateFromPrefs() async {
    try {
      final auth = Get.find<AuthController>();
      if (auth.userId != null || selectedConstituency.value != null) return;
      final savedId = await ConstituencyPrefs.getId();
      if (savedId == null) return;
      if (constituencies.isEmpty) {
        await loadConstituencies();
      }
      final match = constituencies.where((c) => c.id == savedId);
      if (match.isNotEmpty) {
        selectedConstituency.value = match.first;
        return;
      }
      final savedName = await ConstituencyPrefs.getName();
      if (savedName == null) return;
      final byName = constituencies.where((c) => c.name == savedName);
      if (byName.isNotEmpty) {
        selectedConstituency.value = byName.first;
      }
    } catch (_) {}
  }

  Future<void> _hydrateFromSavedProfile() async {
    try {
      final auth = Get.find<AuthController>();
      final uid = auth.userId;
      if (uid == null) return;
      final p = await _userService.getProfile(uid);
      final cid = p?.constituencyId;
      if (cid == null || selectedConstituency.value != null) return;
      await loadConstituencies();
      final dbId = await ConstituencyDbId.resolve(Supabase.instance.client, cid) ??
          (ConstituencyDbId.isNumericId(cid) ? cid : null);
      final match = constituencies.where((c) => c.id == cid || (dbId != null && c.id == dbId));
      if (match.isNotEmpty) {
        await selectConstituency(match.first);
      } else {
        // Saved profile id (numeric, uuid, etc.) does not match [constituencies] list items
        // (e.g. list is seed slugs while profile row uses real PK) — load the row and fetch LBs.
        final idToFetch = dbId ?? cid;
        if (idToFetch != null && idToFetch.isNotEmpty) {
          await _hydrateConstituencyFromDbId(idToFetch);
        }
      }
    } catch (_) {}
  }

  Future<void> _hydrateConstituencyFromDbId(String constituencyPk) async {
    try {
      final row = await Supabase.instance.client
          .from('constituencies')
          .select('id, name, slug')
          .eq('id', constituencyPk)
          .maybeSingle();
      if (row == null) return;
      final c = ConstituencyModel.fromJson(Map<String, dynamic>.from(row));
      await selectConstituency(c);
    } catch (_) {}
  }
}