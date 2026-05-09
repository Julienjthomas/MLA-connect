import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class OnboardingController extends GetxController {
  final _userService = UserService();

  // Language selection
  final RxString selectedLanguage = 'en'.obs;

  // Panchayat/Ward selection
  final RxList<PanchayatModel> panchayats = <PanchayatModel>[].obs;
  final RxList<WardModel> wards = <WardModel>[].obs;
  final Rx<PanchayatModel?> selectedPanchayat = Rx(null);
  final Rx<WardModel?> selectedWard = Rx(null);
  final RxBool loadingPanchayats = false.obs;
  final RxBool loadingWards = false.obs;
  final RxString panchayatSearch = ''.obs;
  final RxString wardSearch = ''.obs;

  List<PanchayatModel> get filteredPanchayats => panchayats
      .where((p) => p.name.toLowerCase().contains(panchayatSearch.value.toLowerCase()))
      .toList();

  List<WardModel> get filteredWards => wards
      .where((w) => w.displayName.toLowerCase().contains(wardSearch.value.toLowerCase()))
      .toList();

  @override
  void onInit() {
    super.onInit();
    loadPanchayats();
  }

  Future<void> loadPanchayats() async {
    loadingPanchayats.value = true;
    try {
      panchayats.value = await _userService.getPanchayats();
    } catch (_) {
      // Use fallback if DB not set up
      panchayats.value = _fallbackPanchayats;
    } finally {
      loadingPanchayats.value = false;
    }
  }

  Future<void> selectPanchayat(PanchayatModel p) async {
    selectedPanchayat.value = p;
    selectedWard.value = null;
    wards.clear();
    loadingWards.value = true;
    try {
      wards.value = await _userService.getWards(p.id);
    } catch (_) {
      wards.value = _fallbackWards;
    } finally {
      loadingWards.value = false;
    }
  }

  // Fallback data for when DB isn't seeded
  static final _fallbackPanchayats = [
    PanchayatModel(id: '1', name: 'Balussery'),
    PanchayatModel(id: '2', name: 'Kodenchery'),
    PanchayatModel(id: '3', name: 'Koorachundu'),
    PanchayatModel(id: '4', name: 'Veliyal'),
  ];

  static final _fallbackWards = List.generate(
    15,
    (i) => WardModel(id: '${i + 1}', panchayatId: '1', number: i + 10, name: _wardNames[i % _wardNames.length]),
  );

  static const _wardNames = [
    'Puthiyangadi', 'Chemmad', 'Kuttikattoor Town', 'Valayamkulam',
    'Parappanangadi', 'Edavanna', 'Mampad', 'Tiruvali', 'Koottilangadi',
    'Tanur', 'Tirur', 'Vettom', 'Vengara', 'Moothedam', 'Thazhekode',
  ];
}
