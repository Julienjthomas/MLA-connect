import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/achievement_model.dart';

class AchievementsService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<AchievementEntry>> getAchievers() async {
    final res = await _db
        .from('achievers')
        .select('full_name, institution, grade')
        .order('position', ascending: true);
    return (res as List)
        .map((row) => AchievementEntry.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }
}
