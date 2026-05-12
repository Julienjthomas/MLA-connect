/// PostgREST often returns [int] for bigint columns; UUIDs stay [String].
String? jsonIdToNullableString(dynamic value) => value?.toString();

String jsonIdToString(dynamic value) => value?.toString() ?? '';
