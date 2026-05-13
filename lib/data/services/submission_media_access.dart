import 'package:supabase_flutter/supabase_flutter.dart';

/// Resolves submission attachment references for the private `submission-objects` bucket.
class SubmissionMediaAccess {
  SubmissionMediaAccess._();

  static const _bucket = 'submission-objects';

  static String objectKeyFromStored(String stored) {
    final value = stored.trim();
    if (value.isEmpty) return value;

    const marker = '/$_bucket/';
    final markerIndex = value.indexOf(marker);
    if (markerIndex >= 0) {
      return value.substring(markerIndex + marker.length);
    }

    return value;
  }

  static bool isSubmissionObjectReference(String stored) {
    final value = stored.trim();
    if (value.isEmpty) return false;
    if (value.contains('/$_bucket/')) return true;
    return value.startsWith('problems/') ||
        value.startsWith('ideas/') ||
        value.startsWith('improvements/') ||
        value.startsWith('appreciations/');
  }

  static String authenticatedObjectUrl(String storedOrPath) {
    final path = objectKeyFromStored(storedOrPath);
    final base = Supabase.instance.client.storage.url;
    return '$base/object/authenticated/$_bucket/$path';
  }

  static Map<String, String> authHeaders() {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token == null || token.isEmpty) return const {};
    return {'Authorization': 'Bearer $token'};
  }
}
