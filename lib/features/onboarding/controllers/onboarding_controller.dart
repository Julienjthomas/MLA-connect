import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class OnboardingController extends GetxController {
  final _userService = UserService();

  final RxString selectedLanguage = 'en'.obs;

  final RxList<LocalBodyModel> localBodies = <LocalBodyModel>[].obs;
  final RxList<WardModel> wards = <WardModel>[].obs;
  final Rx<LocalBodyModel?> selectedLocalBody = Rx(null);
  final Rx<WardModel?> selectedWard = Rx(null);
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
    loadLocalBodies();
  }

  Future<void> loadLocalBodies() async {
    loadingLocalBodies.value = true;
    try {
      localBodies.value = await _userService.getLocalBodies();
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
      wards.value = await _userService.getWards(lb.id);
    } catch (_) {
      wards.value = [];
    } finally {
      loadingWards.value = false;
    }
  }
}
