import 'package:get/get.dart';

import '../../core/constants/app_enums.dart';
import '../models/appreciation/create_appreciation_request.dart';
import '../models/appreciation_model.dart';
import '../remote/appreciation_api.dart';

class AppreciationService {
  AppreciationApi get _api => Get.find<AppreciationApi>();

  Future<List<AppreciationModel>> getMyAppreciations() async {
    final list = await _api.getMyAppreciations();
    return list.map((r) => AppreciationModel(
          id: r.id,
          userId: r.citizenId,
          recipientCategory: r.recipientCategory,
          staffName: r.staffName,
          department: r.department,
          relatedWork: r.relatedWork,
          message: r.message,
          visibility: SubmissionVisibility.values.firstWhere(
            (v) => v.dbValue == r.visibility,
            orElse: () => SubmissionVisibility.public,
          ),
          anonymous: r.anonymous,
          status: SubmissionStatusX.fromString(r.status),
          createdAt: r.createdAt,
          mediaUrls: r.mediaUrls,
        )).toList();
  }

  Future<String> submit(AppreciationFormData data, String userId) async {
    final appreciation = await _api.createAppreciation(
      CreateAppreciationRequest(
        recipientCategory: data.recipientCategory,
        staffName: data.staffName,
        department: data.department,
        relatedWork: data.relatedWork,
        message: data.message,
        visibility: data.visibility.dbValue,
        anonymous: data.anonymous,
        mediaUrls: data.mediaUrls,
      ),
    );
    return appreciation.id;
  }
}
