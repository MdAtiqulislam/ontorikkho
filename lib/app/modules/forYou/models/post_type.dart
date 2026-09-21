import 'package:get/get.dart';
import '../../../../utils/enums.dart';

class Post {
  final String id;
  final String userName;
  final String userImage;
  final String timeAgo;
  final PostType type;
  final String content;

  /// 🔹 Media
  final String? mediaUrl;

  /// 🔹 Video specific
  final VideoSourceType? videoSource;
  final String? videoUrl;

  /// 🔹 Engagement
  RxInt likes = 0.obs;
  RxBool isLiked = false.obs;

  /// 🔹 Reaction (null = no reaction)
  Rx<ReactionType?> reaction = Rx<ReactionType?>(null);

  Post({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.timeAgo,
    required this.type,
    required this.content,

    /// media
    this.mediaUrl,

    /// video
    this.videoSource,
    this.videoUrl,

    int initialLikes = 0,
    ReactionType? initialReaction,
  }) {
    likes.value = initialLikes;
    reaction.value = initialReaction;
    isLiked.value = initialReaction != null;
  }

  /// 🔹 Toggle Like (tap)
  void toggleLike() {
    if (isLiked.value) {
      likes.value--;
      isLiked.value = false;
      reaction.value = null;
    } else {
      likes.value++;
      isLiked.value = true;
      reaction.value = ReactionType.like;
    }
  }

  /// 🔹 Set Reaction (long press)
  void setReaction(ReactionType newReaction) {
    if (!isLiked.value) {
      likes.value++;
    }
    reaction.value = newReaction;
    isLiked.value = true;
  }

  /// 🔹 Helpers
  bool get hasVideo => type == PostType.video && videoUrl != null;
}
