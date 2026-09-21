import 'package:get/get.dart';

import '../app/modules/forYou/models/posts_model.dart';


class PostStore extends GetxController {

  static PostStore get to => Get.find();

  /// Global post cache
  final RxMap<int, SinglePostModel> posts = <int, SinglePostModel>{}.obs;

  /// Save posts to store
  void setPosts(List<SinglePostModel> newPosts) {
    for (var post in newPosts) {
      if (post.id != null) {
        posts[post.id!] = post;
      }
    }
  }

  /// Get post by id
  SinglePostModel? getPost(int id) {
    return posts[id];
  }

  /// Update full post
  void updatePost(SinglePostModel post) {
    if (post.id == null) return;

    posts[post.id!] = post;
    posts.refresh();
  }

  /// Remove post
  void removePost(int id) {
    posts.remove(id);
    posts.refresh();
  }
}