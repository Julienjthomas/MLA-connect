import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class OnboardingController extends GetxController {
  final _userService = UserService();

  // Language selection
  final RxString selectedLanguage = 'en'.obs;

  // LocalBody/Ward selection
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
      localBodies.value = _fallbackLocalBodies;
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
      wards.value = _fallbackWards;
    } finally {
      loadingWards.value = false;
    }
  }

  // Fallback data for when DB isn't seeded
  static final _fallbackLocalBodies = [
    const LocalBodyModel(id: '1', name: 'Balussery', type: 'panchayat'),
    const LocalBodyModel(id: '2', name: 'Kodenchery', type: 'panchayat'),
    const LocalBodyModel(id: '3', name: 'Koorachundu', type: 'panchayat'),
    const LocalBodyModel(id: '4', name: 'Veliyal', type: 'panchayat'),
  ];

  static final _fallbackWards = List.generate(
    15,
    (i) => WardModel(id: '${i + 1}', localBodyId: '1', wardNumber: i + 10, name: _wardNames[i % _wardNames.length]),
  );

  static const _wardNames = [
    'Puthiyangadi',
    'Chemmad',
    'Kuttikattoor Town',
    'Valayamkulam',
    'Parappanangadi',
    'Edavanna',
    'Mampad',
    'Tiruvali',
    'Koottilangadi',
    'Tanur',
    'Tirur',
    'Vettom',
    'Vengara',
    'Moothedam',
    'Thazhekode',
  ];
}
