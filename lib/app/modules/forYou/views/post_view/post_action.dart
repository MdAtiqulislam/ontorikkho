/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/comment_controller.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/for_you_controller.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/reaction_icon.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/reaction_summary.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/extensions.dart';
import '../post_comments/comments_bottom_sheet.dart';
import 'reaction_button.dart';

class PostActions extends GetView<ForYouController> {
  final SinglePostModel post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Counts
        Padding(
          padding:  EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
          child: Row(
            children: [

              Icon(Icons.thumb_up_alt_outlined,size: 16.sp,),
              SizedBox(width: AppDimensions.contentPadding.w,),
              Text("${post.reactionCounts?.totalReactionFormatted}"),
              SizedBox(width: AppDimensions.sectionPadding.w,),
              Icon(Icons.comment,size: 16.sp,),
              SizedBox(width: AppDimensions.contentPadding.w,),
              Text(post.totalCommentsFormatted),
              const Spacer(),
              ReactionSummary(counts: post.reactionCounts??ReactionCounts()),
            ],
          ),
        ),

        const Divider(height: 1),


        /// Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// 👍 Reaction
            ReactionButton(
              onReactionSelected: (reaction) {
                controller.handleReaction(reaction:reaction,post: post);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    ReactionIcon(reaction: post.userReaction?.reactionType?.toReactionType(),),
                  const SizedBox(width: 6),
                  Text(post.userReaction?.reactionType ?? "Like",
                  ),
                ],
              ),
            ),

            /// 💬 Comment
            TextButton.icon(
              onPressed: () async {
                Get.put(CommentsController()).postId=post.id.toString();
                Get.find<CommentsController>().loadComments();
                final result= await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const CommentsBottomSheet(),
                );
                if (result != null) {
                  final index = controller.posts.indexWhere(
                        (element) => element.id == post.id,

                  );

                  print(index);
                  if (index != -1) {


                    final oldPost = controller.posts[index];

                    controller.posts[index] = oldPost.copyWith(
                      comments: result,
                    );
                    controller.posts.refresh();
                  }
                }
              },
              icon: const Icon(Icons.comment_outlined),
              label: const Text("Comment"),
            ),

            /// 🔄 Share
            TextButton.icon(
              onPressed: () {
                controller.sharePost(post);
              },
              icon: const Icon(Icons.share_outlined),
              label: const Text("Share"),
            ),
          ],
        ),
      ],
    );
  }

}*/




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/reaction_icon.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/reaction_summary.dart';
import 'package:ontorikkho/utils/extensions.dart';
import '../../../../../utils/enums.dart';
import 'reaction_button.dart';
class PostActions extends StatelessWidget {
  final SinglePostModel post;
  final Function(ReactionType? reaction) onReaction;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostActions({
    super.key,
    required this.post,
    required this.onReaction,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Counts
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [

              Icon(Icons.thumb_up_alt_outlined, size: 16.sp),
              const SizedBox(width: 6),
              Text("${post.reactionCounts?.totalReactionFormatted}"),

              const SizedBox(width: 16),

              Icon(Icons.comment, size: 16.sp),
              const SizedBox(width: 6),
              Text(post.totalCommentsFormatted),

              const Spacer(),
              ReactionSummary(
                counts: post.reactionCounts ?? ReactionCounts(),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// Reaction
            ReactionButton(
              onReactionSelected: onReaction,
              child: Row(
                children: [
                  ReactionIcon(
                    reaction: post.userReaction?.reactionType?.toReactionType(),
                  ),
                  const SizedBox(width: 6),
                  Text(post.userReaction?.reactionType ?? "Like"),
                ],
              ),
            ),

            /// Comment
            TextButton.icon(
              onPressed: onComment,
              icon: const Icon(Icons.comment_outlined),
              label: const Text("Comment"),
            ),

            /// Share
            TextButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.share_outlined),
              label: const Text("Share"),
            ),
          ],
        ),
      ],
    );
  }
}