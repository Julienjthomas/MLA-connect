import 'package:get/get.dart';
import '../../../data/models/mla_model.dart';
import '../../../data/models/update_model.dart';
import '../../../data/services/mla_service.dart';
import '../../../data/services/updates_service.dart';

class HomeController extends GetxController {
  final _mlaService = MlaService();
  final _updatesService = UpdatesService();

  final Rx<MlaModel?> mla = Rx(null);
  final RxList<UpdateModel> recentActivity = <UpdateModel>[].obs;
  final RxBool loading = false.obs;

  // Hall of Excellence data (static for MVP)
  final hallOfExcellence = [
    {'name': 'Nandana P', 'school': 'GVHSS Kodanchery', 'grade': 'A+', 'achievement': 'SSLC Full A+'},
    {'name': 'Muhammed Shan', 'school': 'HSS Chelari', 'grade': 'A+', 'achievement': 'SSLC Full A+'},
    {'name': 'Arya Krishnan', 'school': 'GHSS Balussery', 'grade': 'A+', 'achievement': 'SSLC Full A+'},
  ];

  final grievanceEvent = {
    'title': 'Public Grievance Hearing',
    'date': 'May 25, 2024 • 10:00 AM',
    'venue': 'Town Hall, Balussery',
  };

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    try {
      await Future.wait([_loadMla(), _loadActivity()]);
    } finally {
      loading.value = false;
    }
  }

  Future<void> _loadMla() async {
    mla.value = await _mlaService.getMlaProfile();
  }

  Future<void> _loadActivity() async {
    final updates = await _updatesService.getUpdates();
    recentActivity.value = updates.take(5).toList();
  }
}
