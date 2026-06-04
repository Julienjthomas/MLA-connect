import 'package:get/get.dart';

import '../../../data/models/post/post_response.dart';
import '../../../data/services/post_service.dart';

class PostsController extends GetxController {
  final _service = PostService();

  final RxList<PostResponse> posts = <PostResponse>[].obs;
  final Rx<PostResponse?> selectedPost = Rx(null);
  final RxBool loading = false.obs;
  final RxBool loadingDetail = false.obs;
  final RxBool liking = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
    _loadDetailIfArgument();
  }

  void _loadDetailIfArgument() {
    final args = Get.arguments;
    if (args is Map && args['id'] != null) {
      loadPost(args['id'] as String);
    }
  }

  Future<void> loadPosts() async {
    loading.value = true;
    try {
      posts.value = await _service.getPosts();
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadPost(String id) async {
    loadingDetail.value = true;
    try {
      selectedPost.value = await _service.getPost(id);
    } finally {
      loadingDetail.value = false;
    }
  }

  Future<void> likePost() async {
    final post = selectedPost.value;
    if (post == null || liking.value) return;
    liking.value = true;
    try {
      await _service.likePost(post.id);
      selectedPost.value = post.copyWith(likes: post.likes + 1);
    } finally {
      liking.value = false;
    }
  }
}
