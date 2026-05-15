class AchievementEntry {
  final String name;
  final String institution;
  final String achievement;
  final String? grade;

  const AchievementEntry({
    required this.name,
    required this.institution,
    required this.achievement,
    this.grade,
  });

  factory AchievementEntry.fromJson(Map<String, dynamic> json) => AchievementEntry(
        name: json['full_name'] as String? ?? '',
        institution: json['institution'] as String? ?? '',
        achievement: json['grade'] as String? ?? 'Achievement',
        grade: json['grade'] as String?,
      );
}
