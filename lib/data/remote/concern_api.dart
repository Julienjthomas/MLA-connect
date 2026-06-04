import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/concern/concern_comment.dart';
import '../models/concern/concern_model.dart';
import '../models/concern/create_concern_request.dart';

part 'concern_api.g.dart';

@RestApi()
abstract class ConcernApi {
  factory ConcernApi(Dio dio, {String? baseUrl}) = _ConcernApi;

  // Citizen-scoped
  @POST('/citizens/:citizenId/concerns')
  Future<ConcernModel> createConcern(@Body() CreateConcernRequest request);

  @GET('/citizens/:citizenId/concerns')
  Future<List<ConcernModel>> getMyConcerns();

  @GET('/citizens/:citizenId/concerns/{concernId}')
  Future<ConcernModel> getConcern(@Path('concernId') String concernId);

  @DELETE('/citizens/:citizenId/concerns/{concernId}')
  Future<void> deleteConcern(@Path('concernId') String concernId);

  // Constituency-scoped
  @GET('/constituencies/{constituencyId}/concerns')
  Future<List<ConcernModel>> getConstituencyConcerns(
    @Path('constituencyId') String constituencyId,
  );

  @GET('/constituencies/{constituencyId}/concerns/{concernId}')
  Future<ConcernModel> getConstituencyConcern(
    @Path('constituencyId') String constituencyId,
    @Path('concernId') String concernId,
  );

  @POST('/constituencies/{constituencyId}/concerns/{concernId}/like')
  Future<void> likeConcern(
    @Path('constituencyId') String constituencyId,
    @Path('concernId') String concernId,
  );

  @GET('/constituencies/{constituencyId}/concerns/{concernId}/comments')
  Future<List<ConcernComment>> getComments(
    @Path('constituencyId') String constituencyId,
    @Path('concernId') String concernId,
  );

  @POST('/constituencies/{constituencyId}/concerns/{concernId}/comments')
  Future<ConcernComment> addComment(
    @Path('constituencyId') String constituencyId,
    @Path('concernId') String concernId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/constituencies/{constituencyId}/concerns/{concernId}/comments/{commentId}')
  Future<void> deleteComment(
    @Path('constituencyId') String constituencyId,
    @Path('concernId') String concernId,
    @Path('commentId') String commentId,
  );
}
