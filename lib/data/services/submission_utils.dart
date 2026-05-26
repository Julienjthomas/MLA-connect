import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// PostgREST embed used to scope “my submissions” to the signed-in auth user.
const kMySubmissionsCitizenEmbed = 'citizens!inner(user_id)';

class SubmissionUtils {
  SubmissionUtils._();

  static const _uuid = Uuid();

  /// Filters [submissions] to rows owned by [client]'s current auth user.
  static String? currentAuthUserId(SupabaseClient client) =>
      client.auth.currentUser?.id;

  /// Generates a random unique submission reference ID as a UUID v4 string.
  /// The [prefix] is accepted for backward compatibility with existing callers
  /// but is no longer included — the returned value is a plain UUID v4.
  static String generateReferenceId([String? prefix]) => _uuid.v4();
}
