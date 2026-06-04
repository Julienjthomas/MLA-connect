import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/mla_model.dart';
import '../../../data/models/post/post_response.dart';
import '../../../data/models/update_model.dart';
import '../../../data/services/event_service.dart';
import '../../../data/services/mla_service.dart';
import '../../../data/services/post_service.dart';
import '../../../data/services/updates_service.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final _mlaService = MlaService();
  final _updatesService = UpdatesService();
  final _eventService = EventService();
  final _postService = PostService();

  final Rx<MlaModel?> mla = Rx(null);
  final RxList<UpdateModel> recentActivity = <UpdateModel>[].obs;
  final RxBool loading = false.obs;
  final RxBool mlaLoading = true.obs;

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
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxList<PostResponse> recentPosts = <PostResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    try {
      await Future.wait([_loadMla(), _loadActivity(), _loadImpact(), _loadAnnouncements(), _loadUpcomingEvents(), _loadRecentPosts()]);
    } finally {
      loading.value = false;
    }
  }

  Future<void> _loadMla() async {
    mlaLoading.value = true;
    try {
      final cid = Get.find<AuthController>().user.value?.constituencyId;
      mla.value = await _mlaService.getMlaProfile(constituencyId: cid);
    } finally {
      mlaLoading.value = false;
    }
  }

  Future<void> _loadImpact() async {
    // TODO: Wire to GET /citizens/:citizenId/activity/summary when available
    // Leaving zeros for now — degrades gracefully
  }

  Future<void> _loadActivity() async {
    try {
      final updates = await _updatesService.getUpdates();
      recentActivity.value = updates.take(5).toList();
    } catch (_) {
      recentActivity.value = [];
    }
  }

  Future<void> _loadAnnouncements() async {
    try {
      final updates = await _updatesService.getUpdates(category: UpdateCategory.announcements);
      announcements.value = updates.take(5).toList();
    } catch (_) {}
  }

  Future<void> _loadUpcomingEvents() async {
    try {
      upcomingEvents.value = await _eventService.getUpcoming(limit: 5);
    } catch (_) {
      upcomingEvents.value = [];
    }
  }

  Future<void> _loadRecentPosts() async {
    try {
      recentPosts.value = await _postService.getRecentPosts();
    } catch (_) {
      recentPosts.value = [];
    }
  }
}
