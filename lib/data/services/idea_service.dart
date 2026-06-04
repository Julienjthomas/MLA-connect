import 'package:get/get.dart';

import '../../core/constants/app_enums.dart';
import '../models/idea/create_idea_request.dart';
import '../models/idea_model.dart';
import '../remote/idea_api.dart';

class IdeaService {
  IdeaApi get _api => Get.find<IdeaApi>();

  Future<List<IdeaModel>> getMyIdeas() async {
    final ideas = await _api.getMyIdeas();
    return ideas.map((r) => IdeaModel(
          id: r.id,
          userId: r.citizenId,
          topic: r.topic,
          title: r.title,
          description: r.description,
          benefits: r.benefits,
          beneficiaries: r.beneficiaries,
          visibility: SubmissionVisibility.values.firstWhere(
            (v) => v.dbValue == r.visibility,
            orElse: () => SubmissionVisibility.public,
          ),
          allowDiscussion: r.allowDiscussion,
          allowContact: r.allowContact,
          status: SubmissionStatusX.fromString(r.status),
          createdAt: r.createdAt,
          mediaUrls: r.mediaUrls,
        )).toList();
  }

  Future<String> submit(IdeaFormData data, String reporterId) async {
    final idea = await _api.createIdea(
      CreateIdeaRequest(
        topic: data.topic,
        title: data.title,
        description: data.description,
        benefits: data.benefits,
        beneficiaries: data.beneficiaries,
        visibility: data.visibility.dbValue,
        allowDiscussion: data.allowDiscussion,
        allowContact: data.allowContact,
        mediaUrls: data.mediaUrls,
      ),
    );
    return idea.id;
  }
}
