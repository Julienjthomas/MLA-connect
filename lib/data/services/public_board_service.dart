import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/constants/app_enums.dart';
import '../models/public_board_item.dart';
import '../remote/appreciation_api.dart';
import '../remote/concern_api.dart';
import '../remote/idea_api.dart';

class PublicBoardService {
  ConcernApi get _concernApi => Get.find<ConcernApi>();
  IdeaApi get _ideaApi => Get.find<IdeaApi>();
  AppreciationApi get _appreciationApi => Get.find<AppreciationApi>();

  Future<List<PublicBoardItem>> getPublicBoard({required String constituencyId}) async {
    try {
      final results = await Future.wait([
        _concernApi.getConstituencyConcerns(constituencyId).then((list) => list
            .map((c) => PublicBoardItem(
                  id: c.id,
                  kind: 'concern',
                  title: c.title,
                  status: SubmissionStatusX.fromString(c.status),
                  createdAt: c.createdAt,
                  mediaUrl: c.mediaUrls.isNotEmpty ? c.mediaUrls.first : null,
                  wardName: c.wardName,
                ))
            .toList()),
        _ideaApi.getConstituencyIdeas(constituencyId).then((list) => list
            .map((i) => PublicBoardItem(
                  id: i.id,
                  kind: 'idea',
                  title: i.title,
                  status: SubmissionStatusX.fromString(i.status),
                  createdAt: i.createdAt,
                  mediaUrl: i.mediaUrls.isNotEmpty ? i.mediaUrls.first : null,
                ))
            .toList()),
        _appreciationApi.getConstituencyAppreciations(constituencyId).then((list) => list
            .map((a) => PublicBoardItem(
                  id: a.id,
                  kind: 'appreciation',
                  title: a.message.length > 80
                      ? '${a.message.substring(0, 80)}...'
                      : a.message,
                  status: SubmissionStatusX.fromString(a.status),
                  createdAt: a.createdAt,
                  mediaUrl: a.mediaUrls.isNotEmpty ? a.mediaUrls.first : null,
                ))
            .toList()),
      ]);

      final all = [...results[0], ...results[1], ...results[2]];
      all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return all.take(50).toList();
    } catch (e) {
      debugPrint('[PublicBoardService] getPublicBoard error: $e');
      return [];
    }
  }
}
