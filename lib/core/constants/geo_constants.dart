abstract class GeoConstants {
  static const List<String> panchayaths = [
    'Balussery',
    'Kuttikattoor',
    'Puthiyangadi',
    'Thiruvallur',
    'Ulliyeri',
    'Unnikulam',
  ];

  static const Map<String, List<String>> wardsByPanchayath = {
    'Balussery': [
      'Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5',
      'Ward 6', 'Ward 7', 'Ward 8', 'Ward 9', 'Ward 10',
      'Ward 11', 'Ward 12', 'Ward 13',
    ],
    'Kuttikattoor': [
      'Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5',
      'Ward 6', 'Ward 7', 'Ward 8', 'Ward 9', 'Ward 10',
    ],
    'Puthiyangadi': [
      'Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5',
      'Ward 6', 'Ward 7', 'Ward 8', 'Ward 9',
    ],
    'Thiruvallur': [
      'Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5',
      'Ward 6', 'Ward 7', 'Ward 8',
    ],
    'Ulliyeri': [
      'Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5',
      'Ward 6', 'Ward 7', 'Ward 8', 'Ward 9', 'Ward 10',
    ],
    'Unnikulam': [
      'Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5',
      'Ward 6', 'Ward 7',
    ],
  };

  static List<String> wardsFor(String? panchayath) {
    if (panchayath == null) return [];
    return wardsByPanchayath[panchayath] ?? [];
  }
}
