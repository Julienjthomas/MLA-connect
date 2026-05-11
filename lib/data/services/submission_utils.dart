import 'dart:math';

class SubmissionUtils {
  SubmissionUtils._();

  static String generateReferenceId(String prefix) {
    final now = DateTime.now();
    final date = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final rand = Random.secure();
    final hex = List.generate(6, (_) => rand.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
    return '$prefix$date$hex';
  }
}
