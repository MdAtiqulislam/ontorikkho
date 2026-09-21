import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/comment_controller.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import '../../../../stores/post_store.dart';
import '../models/post_details_model.dart';

class SinglePostViewController extends GetxController {

  final isLoading = false.obs;
  var post = SinglePostModel().obs;
  final viewAll = false.obs;

  /// Fetch post by postId
  Future<void> getPostDetails(String postId) async
  {
    await _fetchPost(
      endpoint: APIEndPoints.getPostById,
      parameters: {
        "id": postId,
      },
    );
  }

  /// Fetch post with specific comment
  Future<void> getPostDetailsWithCommentId(
      String postId,
      String commentId,
      )
  async {
    await _fetchPost(
      endpoint: APIEndPoints.getPostByIdAndComment,
      parameters: {
        "post_id": postId,
        "comment_id": commentId,
      },
    );
  }

  /// Common API handler
  Future<void> _fetchPost({
    required String endpoint,
    required Map<String, dynamic> parameters,
  }) async
  {

    try {
      isLoading.value = true;

      final response = await RemoteServices.getRequest(
        endpoint: endpoint,
        parameters: parameters,
      );

      if (response != null) {
        final postDetails = PostDetailsModel.fromJson(response);
        post.value = postDetails.data ?? SinglePostModel();
        PostStore.to.updatePost(post.value);
        update();
        Get.find<CommentsController>().postId= post.value.id??0;
        Get.find<CommentsController>().comments.value=postDetails.data?.comments??[];
      }

    } catch (e) {
      print("Post fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }


}

