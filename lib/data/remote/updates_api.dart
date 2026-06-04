import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/post/post_response.dart';

part 'updates_api.g.dart';

@RestApi()
abstract class UpdatesApi {
  factory UpdatesApi(Dio dio, {String? baseUrl}) = _UpdatesApi;

  @GET('/constituencies/{constituencyId}/posts')
  Future<List<PostResponse>> getPosts(
    @Path('constituencyId') String constituencyId, {
    @Query('category') String? category,
  });

  @GET('/constituencies/{constituencyId}/posts/{postId}')
  Future<PostResponse> getPost(
    @Path('constituencyId') String constituencyId,
    @Path('postId') String postId,
  );

  @POST('/constituencies/{constituencyId}/posts/{postId}/like')
  Future<void> likePost(
    @Path('constituencyId') String constituencyId,
    @Path('postId') String postId,
  );

  @GET('/constituencies/posts/recent')
  Future<List<PostResponse>> getRecentPosts();
}
