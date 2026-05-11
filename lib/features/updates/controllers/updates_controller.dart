import 'package:get/get.dart';
import '../../../core/constants/app_enums.dart';
import '../../../data/models/update_model.dart';
import '../../../data/services/updates_service.dart';

class UpdatesController extends GetxController {
  final _service = UpdatesService();

  final RxList<UpdateModel> updates = <UpdateModel>[].obs;
  final Rx<UpdateCategory> selectedCategory = UpdateCategory.all.obs;
  final RxBool loading = false.obs;
  final Rx<UpdateModel?> selectedUpdate = Rx(null);
  final RxSet<String> likedIds = <String>{}.obs;

  List<UpdateModel> get filteredUpdates {
    if (selectedCategory.value == UpdateCategory.all) return updates;
    return updates.where((u) => u.category == selectedCategory.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadUpdates();
  }

  Future<void> loadUpdates() async {
    loading.value = true;
    try {
      final list = await _service.getUpdates();
      if (list.isEmpty) {
        updates.value = _mockUpdates;
      } else {
        updates.value = list;
      }
    } catch (_) {
      updates.value = _mockUpdates;
    } finally {
      loading.value = false;
    }
  }

  void selectCategory(UpdateCategory cat) => selectedCategory.value = cat;

  void toggleLike(String id) {
    final idx = updates.indexWhere((u) => u.id == id);
    if (idx == -1) return;
    final u = updates[idx];
    if (likedIds.contains(id)) {
      likedIds.remove(id);
      updates[idx] = UpdateModel(
        id: u.id, title: u.title, body: u.body,
        titleMl: u.titleMl, bodyMl: u.bodyMl,
        category: u.category, imageUrl: u.imageUrl,
        likes: (u.likes - 1).clamp(0, 999999), views: u.views,
        createdAt: u.createdAt,
      );
    } else {
      likedIds.add(id);
      updates[idx] = UpdateModel(
        id: u.id, title: u.title, body: u.body,
        titleMl: u.titleMl, bodyMl: u.bodyMl,
        category: u.category, imageUrl: u.imageUrl,
        likes: u.likes + 1, views: u.views,
        createdAt: u.createdAt,
      );
    }
  }

  static final _mockUpdates = [
    UpdateModel(
      id: '1', title: 'Road overlay work started at Kuttikattoor',
      body: 'The long-awaited road repair work has begun at Kuttikattoor junction. The Public Works Department is conducting complete road overlay to fix the damaged stretch near the Juma Masjid. Work is expected to complete within 3 weeks.',
      category: UpdateCategory.development,
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&q=80',
      likes: 123, views: 456, createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UpdateModel(
      id: '2', title: 'Water issue resolved at Puthiyangadi',
      body: 'The water supply issue reported by residents at Puthiyangadi has been successfully resolved. A new pipeline was installed connecting 45 households to the main water supply network.',
      category: UpdateCategory.resolved,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      likes: 96, views: 230, createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    UpdateModel(
      id: '3', title: 'Visited Govt. Higher Secondary School, Balussery',
      body: 'MLA V T Sooraj visited the Government Higher Secondary School Balussery to review the progress of the infrastructure upgrade project funded under the constituency development fund.',
      category: UpdateCategory.development,
      imageUrl: 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=800&q=80',
      likes: 142, views: 380, createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UpdateModel(
      id: '4', title: 'Public Grievance Hearing — May 25, 2024',
      body: 'The MLA Office announces a Public Grievance Hearing on May 25, 2024 at 10:00 AM at the Town Hall, Balussery. Citizens can bring their complaints and requests directly to the MLA.',
      category: UpdateCategory.events,
      imageUrl: null,
      likes: 65, views: 180, createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    UpdateModel(
      id: '5', title: 'Smart Drainage System proposed for flood-prone areas',
      body: 'A citizen-submitted idea for installing smart drainage sensors in flood-prone areas of Balussery has been accepted for review. The system would provide real-time alerts during heavy rains.',
      category: UpdateCategory.announcements,
      imageUrl: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&q=80',
      likes: 48, views: 120, createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
