import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/constituency_seed.dart';
import 'json_ids.dart';

/// Resolves onboarding / seed values (slug, legacy UUID) to [constituencies.id] for bigint PKs.
abstract class ConstituencyDbId {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  static bool isNumericId(String value) => _digitsOnly.hasMatch(value.trim());

  /// Returns a string safe for `.eq('constituency_id', …)` / inserts, or null if unknown.
  static Future<String?> resolve(SupabaseClient db, String? raw) async {
    if (raw == null) return null;
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (isNumericId(t)) return t;

    final slug = ConstituencySeed.legacyUuidToSlug[t] ??
        (ConstituencySeed.knownSlugs.contains(t) ? t : null);
    if (slug != null) {
      return _lookupBySlugOrName(db, slug);
    }

    if (RegExp(r'^[a-z][a-z0-9_-]*$').hasMatch(t)) {
      return _lookupBySlugOrName(db, t);
    }
    return null;
  }

  static Future<String?> _lookupBySlugOrName(SupabaseClient db, String slug) async {
    final name = ConstituencySeed.displayNameForSlug(slug);
    if (name != null) {
      try {
        final row = await db.from('constituencies').select('id').eq('name', name).maybeSingle();
        if (row != null) return jsonIdToString(row['id']);
      } catch (_) {}
    }
    return null; // no slug column in DB
  }
}
