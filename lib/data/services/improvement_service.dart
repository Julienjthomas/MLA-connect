import 'package:get/get.dart';

import '../../core/constants/app_enums.dart';
import '../models/concern/create_concern_request.dart';
import '../models/improvement_model.dart';
import '../remote/concern_api.dart';

class ImprovementService {
  ConcernApi get _api => Get.find<ConcernApi>();

  Future<List<ImprovementModel>> getMyImprovements() async {
    final concerns = await _api.getMyConcerns();
    return concerns
        .where((c) => c.category == 'suggestion' || c.category == 'improvement')
        .map((c) => ImprovementModel(
              id: c.id,
              userId: c.citizenId,
              title: c.title,
              suggestion: c.description,
              department: c.category,
              location: c.location,
              landmark: c.landmark,
              status: SubmissionStatusX.fromString(c.status),
              createdAt: c.createdAt,
              mediaUrls: c.mediaUrls,
            ))
        .toList();
  }

  Future<String> submit(ImprovementFormData data, String reporterId) async {
    final concern = await _api.createConcern(
      CreateConcernRequest(
        category: 'suggestion',
        title: data.suggestion.length > 80
            ? '${data.suggestion.substring(0, 80)}...'
            : data.suggestion,
        description: data.suggestion,
        location: data.location,
        landmark: data.landmark,
        wardId: data.wardId,
        localBodyId: data.localBodyId,
        mediaUrls: data.mediaUrls,
      ),
    );
    return concern.id;
  }
}
