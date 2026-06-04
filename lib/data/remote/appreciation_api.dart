import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/appreciation/appreciation_comment.dart';
import '../models/appreciation/appreciation_response.dart';
import '../models/appreciation/create_appreciation_request.dart';

part 'appreciation_api.g.dart';

@RestApi()
abstract class AppreciationApi {
  factory AppreciationApi(Dio dio, {String? baseUrl}) = _AppreciationApi;

  // Citizen-scoped
  @POST('/citizens/:citizenId/appreciations')
  Future<AppreciationResponse> createAppreciation(
      @Body() CreateAppreciationRequest request);

  @GET('/citizens/:citizenId/appreciations')
  Future<List<AppreciationResponse>> getMyAppreciations();

  @GET('/citizens/:citizenId/appreciations/{appreciationId}')
  Future<AppreciationResponse> getAppreciation(
      @Path('appreciationId') String appreciationId);

  @DELETE('/citizens/:citizenId/appreciations/{appreciationId}')
  Future<void> deleteAppreciation(
      @Path('appreciationId') String appreciationId);

  // Constituency-scoped
  @GET('/constituencies/{constituencyId}/appreciations')
  Future<List<AppreciationResponse>> getConstituencyAppreciations(
      @Path('constituencyId') String constituencyId);

  @GET('/constituencies/{constituencyId}/appreciations/{appreciationId}')
  Future<AppreciationResponse> getConstituencyAppreciation(
    @Path('constituencyId') String constituencyId,
    @Path('appreciationId') String appreciationId,
  );

  @POST('/constituencies/{constituencyId}/appreciations/{appreciationId}/like')
  Future<void> likeAppreciation(
    @Path('constituencyId') String constituencyId,
    @Path('appreciationId') String appreciationId,
  );

  @GET('/constituencies/{constituencyId}/appreciations/{appreciationId}/comments')
  Future<List<AppreciationComment>> getComments(
    @Path('constituencyId') String constituencyId,
    @Path('appreciationId') String appreciationId,
  );

  @POST('/constituencies/{constituencyId}/appreciations/{appreciationId}/comments')
  Future<AppreciationComment> addComment(
    @Path('constituencyId') String constituencyId,
    @Path('appreciationId') String appreciationId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(
      '/constituencies/{constituencyId}/appreciations/{appreciationId}/comments/{commentId}')
  Future<void> deleteComment(
    @Path('constituencyId') String constituencyId,
    @Path('appreciationId') String appreciationId,
    @Path('commentId') String commentId,
  );
}
