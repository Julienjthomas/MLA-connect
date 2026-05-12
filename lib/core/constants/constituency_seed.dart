/// Fallback geography when Supabase rows are incomplete (demo / migration lag).
/// Keys use [slug] so they stay valid when [constituencies.id] is bigint in production.
abstract class ConstituencySeed {
  static const balusserySlug = 'balussery';
  static const koduvalliSlug = 'koduvalli';
  static const perambraSlug = 'perambra';

  /// Old demo IDs (UUID) → slug, for clients that still hold them in memory.
  static const Map<String, String> legacyUuidToSlug = {
    '00000000-0000-0000-0000-000000000001': balusserySlug,
    '00000000-0000-0000-0000-000000000002': koduvalliSlug,
    '00000000-0000-0000-0000-000000000003': perambraSlug,
  };

  static const Set<String> knownSlugs = {balusserySlug, koduvalliSlug, perambraSlug};

  static const Map<String, String> slugToDisplayName = {
    balusserySlug: 'Balussery',
    koduvalliSlug: 'Koduvalli',
    perambraSlug: 'Perambra',
  };

  static String? displayNameForSlug(String slug) => slugToDisplayName[slug];

  /// Maps a DB constituency [name] back to our seed slug (ward / panchayat maps).
  static String? slugForConstituencyName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final t = name.trim().toLowerCase();
    for (final e in slugToDisplayName.entries) {
      if (e.value.toLowerCase() == t) return e.key;
    }
    return null;
  }

  static const List<Map<String, String>> constituencies = [
    {'id': balusserySlug, 'name': 'Balussery', 'slug': balusserySlug},
    {'id': koduvalliSlug, 'name': 'Koduvalli', 'slug': koduvalliSlug},
    {'id': perambraSlug, 'name': 'Perambra', 'slug': perambraSlug},
  ];

  static const Map<String, List<String>> panchayathsByConstituency = {
    balusserySlug: [
      'Atholi',
      'Balussery',
      'Kayanna',
      'Koorachundu',
      'Kottur',
      'Naduvannur',
      'Panangad',
      'Ulliyeri',
      'Unnikulam',
    ],
    koduvalliSlug: [
      'Kodenchery',
      'Kizhakkoth',
      'Madavoor',
      'Narikkuni',
      'Omassery',
      'Puduppadi',
      'Thamarassery',
      'Kattippara',
      'Kodanchery',
      'Koduvalli',
    ],
    perambraSlug: [
      'Arikkulam',
      'Chakkittapara',
      'Changaroth',
      'Cheruvannur',
      'Keezhariyur',
      'Koothali',
      'Meppayur',
      'Nochad',
      'Perambra',
      'Thurayur',
    ],
  };

  /// Ward labels for pickers when DB has no ward rows yet (Ward 1 … Ward n).
  static const Map<String, Map<String, int>> wardCountsByPanchayath = {
    balusserySlug: {
      'Atholi': 18,
      'Balussery': 18,
      'Kayanna': 13,
      'Koorachundu': 15,
      'Kottur': 15,
      'Naduvannur': 16,
      'Panangad': 14,
      'Ulliyeri': 21,
      'Unnikulam': 16,
    },
  };
}
