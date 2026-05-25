import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<List<EventModel>> getEvents({int limit = 50}) async {
    final res = await _db
        .from('events')
        .select()
        .order('starts_at', ascending: false)
        .limit(limit);
    return (res as List)
        .map((j) => EventModel.fromJson(Map<String, dynamic>.from(j as Map)))
        .toList();
  }

  Future<List<EventModel>> getUpcoming({int limit = 5}) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final res = await _db
        .from('events')
        .select()
        .gte('starts_at', now)
        .order('starts_at', ascending: true)
        .limit(limit);
    return (res as List)
        .map((j) => EventModel.fromJson(Map<String, dynamic>.from(j as Map)))
        .toList();
  }
}
