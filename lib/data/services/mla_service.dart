import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mla_model.dart';

class MlaService {
  SupabaseClient get _db => Supabase.instance.client;

  Future<MlaModel> getMlaProfile() async {
    try {
      final res = await _db.from('mla_profile').select().limit(1).single();
      return MlaModel.fromJson(res);
    } catch (_) {
      return MlaModel.placeholder;
    }
  }
}
