import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/mla_model.dart';
import '../../../data/models/update_model.dart';
import '../../../data/services/mla_service.dart';
import '../../../data/services/updates_service.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final _mlaService = MlaService();
  final _updatesService = UpdatesService();

  final Rx<MlaModel?> mla = Rx(null);
  final RxList<UpdateModel> recentActivity = <UpdateModel>[].obs;
  final RxBool loading = false.obs;

  // Community Impact stats — current month, constituency-scoped
  final RxInt impactReports = 0.obs;
  final RxInt impactIdeas = 0.obs;
  final RxInt impactAppreciations = 0.obs;

  // Hall of Excellence data (static for MVP)
  final hallOfExcellence = [
    {'name': 'Nandana P', 'school': 'GVHSS Kodanchery', 'grade': 'A+', 'achievement': 'SSLC Full A+'},
    {'name': 'Muhammed Shan', 'school': 'HSS Chelari', 'grade': 'A+', 'achievement': 'SSLC Full A+'},
    {'name': 'Arya Krishnan', 'school': 'GHSS Kodanchery', 'grade': 'A+', 'achievement': 'SSLC Full A+'},
  ];

  final RxList<UpdateModel> announcements = <UpdateModel>[].obs;
  final RxList<UpdateModel> upcomingEvents = <UpdateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    try {
      await Future.wait([_loadMla(), _loadActivity(), _loadImpact(), _loadAnnouncements(), _loadUpcomingEvents()]);
    } finally {
      loading.value = false;
    }
  }

  Future<void> _loadMla() async {
    final cid = Get.find<AuthController>().user.value?.constituencyId;
    mla.value = await _mlaService.getMlaProfile(constituencyId: cid);
  }

  Future<void> _loadImpact() async {
    try {
      final cid = Get.find<AuthController>().user.value?.constituencyId;
      if (cid == null) return;
      final supabase = Supabase.instance.client;
      final now = DateTime.now().toUtc();
      final monthStart = DateTime.utc(now.year, now.month, 1).toIso8601String();

      Future<int> countKind(String kind) async {
        final rows = await supabase
            .from('submissions')
            .select('id, citizens!inner(constituency_id)')
            .eq('kind', kind)
            .eq('citizens.constituency_id', cid)
            .gte('created_at', monthStart);
        return (rows as List).length;
      }

      final results = await Future.wait([
        countKind('report'),
        countKind('idea'),
        countKind('appreciation'),
      ]);
      impactReports.value = results[0];
      impactIdeas.value = results[1];
      impactAppreciations.value = results[2];
    } catch (_) {
      // leave zeros — section degrades gracefully
    }
  }

  Future<void> _loadActivity() async {
    try {
      final updates = await _updatesService.getUpdates();
      if (updates.isNotEmpty) {
        recentActivity.value = updates.take(5).toList();
      }
    } catch (_) {}
  }

  Future<void> _loadAnnouncements() async {
    try {
      final updates = await _updatesService.getUpdates(category: UpdateCategory.announcements);
      announcements.value = updates.take(5).toList();
    } catch (_) {}
  }

  Future<void> _loadUpcomingEvents() async {
    try {
      final updates = await _updatesService.getUpdates(category: UpdateCategory.events);
      upcomingEvents.value = updates.where((u) => u.imageUrl != null).take(10).toList();
    } catch (_) {}
  }
}
