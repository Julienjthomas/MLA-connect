import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('MMM d, yyyy').format(dt);
  }

  static String display(DateTime dt) => DateFormat('MMM d, yyyy').format(dt);

  static String displayFull(DateTime dt) => DateFormat('MMMM d, yyyy • h:mm a').format(dt);

  static String eventDate(DateTime dt) => DateFormat('MMMM d, yyyy • h:mm a').format(dt);

  static String shortDate(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);
}
