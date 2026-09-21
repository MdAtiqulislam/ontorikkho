import 'package:get/get.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../../stores/post_store.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/extensions.dart';
import '../models/posts_model.dart';


class ReactionManager extends GetxController {
  static ReactionManager get to => Get.find<ReactionManager>();

  var isUpdating = false.obs;

  /// Handle all reaction cases
  Future<void> handleReaction({
    required SinglePostModel post,
    ReactionType? reaction,
  }) async {
    final currentReaction = post.userReaction?.reactionType;

    // No reaction before → default Like
    if (currentReaction == null && reaction == null) {
      await addReaction(post, ReactionType.like);
      return;
    }

    // No reaction before → selected reaction
    if (currentReaction == null && reaction != null) {
      await addReaction(post, reaction);
      return;
    }

    // Reaction exists → tap same or empty → remove
    if (currentReaction != null &&
        (reaction == null || currentReaction == reaction.name)) {
      await removeReaction(post);
      return;
    }

    // Reaction exists → select different reaction
    if (currentReaction != null && reaction != null) {
      await updateReaction(post, reaction);
    }
  }

  /// Add reaction
  Future<void> addReaction(SinglePostModel post, ReactionType reaction) async {
    isUpdating.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.addReaction,
        body: {
          "post_id": post.id.toString(),
          "reaction_type": reaction.name,
        },
      );

      if (res != null) {
        final newReaction = UserReaction().copyWith(
          id: int.parse(res["data"]["id"].toString()),
          postId: int.parse(res["data"]["post_id"].toString()),
          userId: int.parse(res["data"]["user_id"].toString()),
          reactionType: res["data"]["reaction_type"],
          createdAt: res["data"]["created_at"],
        );

        _updatePostReaction(post, newReaction);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  /// Remove reaction
  Future<void> removeReaction(SinglePostModel post) async {
    isUpdating.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.removeReaction,
        body: {"id": post.userReaction?.id.toString()},
      );

      if (res != null) {
        _updatePostReaction(post, null); // remove reaction
      }
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update reaction
  Future<void> updateReaction(SinglePostModel post, ReactionType reaction) async {
    isUpdating.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.updateReaction,
        body: {
          "id": post.userReaction?.id.toString(),
          "reaction_type": reaction.name,
        },
      );

      if (res != null) {
        final newReaction = UserReaction().copyWith(
          id: res["data"]["id"],
          postId: res["data"]["post_id"],
          userId: res["data"]["user_id"],
          reactionType: res["data"]["reaction_type"],
          createdAt: res["data"]["created_at"],
        );

        _updatePostReaction(post, newReaction);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  /// Internal helper to update PostStore + reaction counts
  void _updatePostReaction(SinglePostModel post, UserReaction? newReaction) {
    final oldReaction = post.userReaction?.reactionType?.toReactionType();
    ReactionCounts counts = post.reactionCounts ?? ReactionCounts.empty();

    // Remove old reaction
    if (oldReaction != null) counts = counts.update(oldReaction, -1);

    // Add new reaction
    if (newReaction != null) counts = counts.update(newReaction.reactionType!.toReactionType(), 1);

    final updatedPost = post.copyWith(
      userReaction: (newReaction == null || newReaction.reactionType == null)
          ? UserReaction()
          : newReaction,
      reactionCounts: counts,
    );

    PostStore.to.updatePost(updatedPost);
  }
}