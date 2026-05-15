import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/office_message_model.dart';

class OfficeMessagesService {
  SupabaseClient get _db => Supabase.instance.client;

  /// Returns the thread id for this citizen+constituency, creating one if needed.
  Future<String?> _ensureThread({
    required int citizenId,
    required int constituencyId,
  }) async {
    // Try to fetch existing thread first
    final existing = await _db
        .from('contact_threads')
        .select('id')
        .eq('citizen_id', citizenId)
        .eq('constituency_id', constituencyId)
        .maybeSingle();
    if (existing != null) return existing['id'] as String;

    // Create new thread
    final created = await _db
        .from('contact_threads')
        .insert({'citizen_id': citizenId, 'constituency_id': constituencyId})
        .select('id')
        .single();
    return created['id'] as String;
  }

  Future<List<OfficeMessageModel>> listForThread({
    required int citizenId,
    required int constituencyId,
    int limit = 50,
  }) async {
    try {
      final thread = await _db
          .from('contact_threads')
          .select('id')
          .eq('citizen_id', citizenId)
          .eq('constituency_id', constituencyId)
          .maybeSingle();
      if (thread == null) return [];

      final res = await _db
          .from('contact_messages')
          .select()
          .eq('thread_id', thread['id'] as String)
          .order('created_at', ascending: true)
          .limit(limit) as List<dynamic>;
      return res.map((j) => OfficeMessageModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> send({
    required int citizenId,
    required int constituencyId,
    required String body,
  }) async {
    final threadId = await _ensureThread(citizenId: citizenId, constituencyId: constituencyId);
    if (threadId == null) return;
    await _db.from('contact_messages').insert({
      'thread_id': threadId,
      'sender_type': 'citizen',
      'body': body,
    });
  }
}
