import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_enums.dart';
import '../../data/supabase/supabase_config.dart';
import '../models/update_model.dart';

class UpdatesService {
  SupabaseClient get _db => Supabase.instance.client;

  static final _mockUpdates = [
    UpdateModel(
      id: '1',
      title: 'New Road Laid at Kodanchery Junction',
      body:
          'A 2km stretch of road from Kodanchery junction to the ward boundary has been newly paved under the PMGSY scheme. Work completed ahead of schedule.',
      category: UpdateCategory.development,
      imageUrl: 'https://picsum.photos/seed/road1/400/200',
      likes: 42,
      views: 318,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UpdateModel(
      id: '2',
      title: 'Constituency Day Celebrations 2024',
      body:
          'Join us for the annual Constituency Day celebrations at Town Hall, Balussery. Cultural programs, awards, and community lunch.',
      category: UpdateCategory.events,
      imageUrl: 'https://picsum.photos/seed/event3/400/200',
      likes: 87,
      views: 512,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    UpdateModel(
      id: '3',
      title: 'Water Supply Issue in Ward 7 Resolved',
      body:
          'The pipe burst at Chelari main road that disrupted water supply to Ward 7 has been repaired. Normal supply restored.',
      category: UpdateCategory.resolved,
      imageUrl: 'https://picsum.photos/seed/water3/400/200',
      likes: 61,
      views: 290,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    UpdateModel(
      id: '4',
      title: 'MLA Fund Allocation — 2024 Projects',
      body:
          'Announcing the MLA Local Area Development Fund allocations for 2024. Priority given to road repairs, drinking water, and street lighting.',
      category: UpdateCategory.announcements,
      imageUrl: 'https://picsum.photos/seed/govt4/400/200',
      likes: 104,
      views: 680,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    UpdateModel(
      id: '5',
      title: 'Public Library Renovation Complete',
      body:
          'The Balussery public library renovation is now complete. New reading hall, digital section, and children\'s corner now open to all residents.',
      category: UpdateCategory.development,
      imageUrl: 'https://picsum.photos/seed/library5/400/200',
      likes: 55,
      views: 234,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  Future<List<UpdateModel>> getUpdates({UpdateCategory? category}) async {
    if (SupabaseConfig.demoMode) {
      final all = _mockUpdates;
      if (category == null || category == UpdateCategory.all) return all;
      return all.where((u) => u.category == category).toList();
    }
    var query = _db.from('updates').select().order('created_at', ascending: false);
    final res = await query;
    final all = (res as List).map((j) => UpdateModel.fromJson(j as Map<String, dynamic>)).toList();
    if (category == null || category == UpdateCategory.all) return all;
    return all.where((u) => u.category == category).toList();
  }

  Future<UpdateModel?> getUpdate(String id) async {
    if (SupabaseConfig.demoMode) {
      return _mockUpdates.where((u) => u.id == id).firstOrNull;
    }
    final res = await _db.from('updates').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return UpdateModel.fromJson(res);
  }

  Future<void> likeUpdate(String id) async {
    if (SupabaseConfig.demoMode) return;
    await _db.rpc('increment_likes', params: {'row_id': id});
  }
}
