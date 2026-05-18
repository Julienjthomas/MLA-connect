import 'package:uuid/uuid.dart';

class SubmissionUtils {
  SubmissionUtils._();

  static const _uuid = Uuid();

  /// Generates a random unique submission reference ID as a UUID v4 string.
  /// The [prefix] is accepted for backward compatibility with existing callers
  /// but is no longer included — the returned value is a plain UUID v4.
  static String generateReferenceId([String? prefix]) => _uuid.v4();
}
