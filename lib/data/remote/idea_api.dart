import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/idea/create_idea_request.dart';
import '../models/idea/idea_comment.dart';
import '../models/idea/idea_response.dart';

part 'idea_api.g.dart';

@RestApi()
abstract class IdeaApi {
  factory IdeaApi(Dio dio, {String? baseUrl}) = _IdeaApi;

  // Citizen-scoped
  @POST('/citizens/:citizenId/ideas')
  Future<IdeaResponse> createIdea(@Body() CreateIdeaRequest request);

  @GET('/citizens/:citizenId/ideas')
  Future<List<IdeaResponse>> getMyIdeas();

  @GET('/citizens/:citizenId/ideas/{ideaId}')
  Future<IdeaResponse> getIdea(@Path('ideaId') String ideaId);

  @DELETE('/citizens/:citizenId/ideas/{ideaId}')
  Future<void> deleteIdea(@Path('ideaId') String ideaId);

  // Constituency-scoped
  @GET('/constituencies/{constituencyId}/ideas')
  Future<List<IdeaResponse>> getConstituencyIdeas(
    @Path('constituencyId') String constituencyId,
  );

  @GET('/constituencies/{constituencyId}/ideas/{ideaId}')
  Future<IdeaResponse> getConstituencyIdea(
    @Path('constituencyId') String constituencyId,
    @Path('ideaId') String ideaId,
  );

  @POST('/constituencies/{constituencyId}/ideas/{ideaId}/upvote')
  Future<void> upvote(
    @Path('constituencyId') String constituencyId,
    @Path('ideaId') String ideaId,
  );

  @POST('/constituencies/{constituencyId}/ideas/{ideaId}/downvote')
  Future<void> downvote(
    @Path('constituencyId') String constituencyId,
    @Path('ideaId') String ideaId,
  );

  @GET('/constituencies/{constituencyId}/ideas/{ideaId}/comments')
  Future<List<IdeaComment>> getComments(
    @Path('constituencyId') String constituencyId,
    @Path('ideaId') String ideaId,
  );

  @POST('/constituencies/{constituencyId}/ideas/{ideaId}/comments')
  Future<IdeaComment> addComment(
    @Path('constituencyId') String constituencyId,
    @Path('ideaId') String ideaId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/constituencies/{constituencyId}/ideas/{ideaId}/comments/{commentId}')
  Future<void> deleteComment(
    @Path('constituencyId') String constituencyId,
    @Path('ideaId') String ideaId,
    @Path('commentId') String commentId,
  );
}
