import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../features/auth/controllers/auth_controller.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.citizenId,
    required this.name,
    required this.contributionCount,
    this.avatarUrl,
  });
  final int rank;
  final String citizenId;
  final String name;
  final int contributionCount;
  final String? avatarUrl;
}

class BadgeTier {
  const BadgeTier({required this.name, required this.minCount, required this.emoji});
  final String name;
  final int minCount;
  final String emoji;
}

const _badgeTiers = [
  BadgeTier(name: 'Legend', minCount: 50, emoji: '🏆'),
  BadgeTier(name: 'Leader', minCount: 25, emoji: '⭐'),
  BadgeTier(name: 'Champion', minCount: 10, emoji: '🥇'),
  BadgeTier(name: 'Active', minCount: 5, emoji: '🔥'),
  BadgeTier(name: 'Starter', minCount: 1, emoji: '🌱'),
];

class LeaderboardController extends GetxController {
  final RxList<LeaderboardEntry> entries = <LeaderboardEntry>[].obs;
  final RxBool loading = false.obs;

  String? get currentUserId => Get.isRegistered<AuthController>()
      ? Get.find<AuthController>().userId
      : null;

  int get userContributionCount =>
      Get.isRegistered<AuthController>()
          ? 0  // Will be populated from profile once contribution_count is in UserModel
          : 0;

  BadgeTier? get currentBadge {
    final count = userContributionCount;
    for (final tier in _badgeTiers) {
      if (count >= tier.minCount) return tier;
    }
    return null;
  }

  BadgeTier? badgeForCount(int count) {
    for (final tier in _badgeTiers) {
      if (count >= tier.minCount) return tier;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    loading.value = true;
    try {
      final cid = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().user.value?.constituencyId
          : null;
      if (cid == null) return;
      final dio = Get.find<Dio>();
      final resp = await dio.get('/constituencies/$cid/leaderboard');
      final body = resp.data;
      if (body is! Map<String, dynamic>) return;
      final data = (body['data'] ?? body);
      List? items;
      if (data is Map) {
        items = data['items'] as List?;
      } else if (data is List) {
        items = data;
      }
      if (items == null) return;
      entries.value = items
          .whereType<Map<String, dynamic>>()
          .toList()
          .asMap()
          .entries
          .map((e) => LeaderboardEntry(
                rank: e.key + 1,
                citizenId: e.value['id']?.toString() ?? '',
                name: e.value['full_name'] as String? ?? 'Citizen',
                contributionCount: e.value['contribution_count'] as int? ?? 0,
                avatarUrl: e.value['avatar_url'] as String?,
              ))
          .toList();
    } catch (e) {
      debugPrint('[LeaderboardController] loadLeaderboard error: $e');
    } finally {
      loading.value = false;
    }
  }
}
