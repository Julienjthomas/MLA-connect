import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/appreciation/appreciation_response.dart';
import '../models/idea/idea_response.dart';
import '../models/mla/constituency_summary_response.dart';
import '../models/mla/mla_response.dart';
import '../models/event/public_event_response.dart';
import '../models/post/post_response.dart';

part 'mla_api.g.dart';

@RestApi()
abstract class MlaApi {
  factory MlaApi(Dio dio, {String? baseUrl}) = _MlaApi;

  @GET('/constituencies/{constituencyId}/mla')
  Future<MlaResponse> getMla(@Path('constituencyId') String constituencyId);

  @GET('/constituencies/{constituencyId}/summary')
  Future<ConstituencySummaryResponse> getSummary(
      @Path('constituencyId') String constituencyId);

  @GET('/constituencies/posts/recent')
  Future<List<PostResponse>> getRecentPosts();

  @GET('/constituencies/appreciations/trending')
  Future<List<AppreciationResponse>> getTrendingAppreciations();

  @GET('/constituencies/ideas/top')
  Future<List<IdeaResponse>> getTopIdeas();

  @GET('/constituencies/public-events/upcoming')
  Future<List<PublicEventResponse>> getUpcomingEvents();
}
