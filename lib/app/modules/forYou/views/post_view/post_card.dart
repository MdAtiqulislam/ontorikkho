
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_action.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_content_builder.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_header.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_text_content.dart';
import 'package:ontorikkho/app/modules/pageFeed/models/page_details_model.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/app/modules/singlePostView/controllers/single_post_view_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../../common_widgets/link_preview.dart';
import '../../../../../stores/post_store.dart';
import '../../../../../utils/util.dart';
import '../../../profileFeed/controllers/profile_feed_controller.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/for_you_controller.dart';
import '../../controllers/reaction_manager.dart';
import '../../controllers/share_post_controller.dart';
import '../post_comments/comments_bottom_sheet.dart';
import '../post_share/post_share_bottom_sheet.dart';
import 'multi_media_preview.dart';

class PostCard extends StatelessWidget {
  final int postId;
  final dynamic controller;
  final PageDataModel? pageDataModel;


  const PostCard({
    this.pageDataModel,
    super.key, required this.postId, required this.controller});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      final post = PostStore.to.posts[postId];
      if (post == null) return const SizedBox.shrink(); // post null হলে কিছু দেখাবে না

      return InkWell(
        onTap: () {
          Get.put(SinglePostViewController()).post.value = post;
          Get.find<CommentsController>().postId= post.id??0;
          Get.toNamed(Routes.SINGLE_POST_VIEW);
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
              ),
              child: PostHeader(
                post: post,
                page:pageDataModel,
                onDelete: () {
                  controller.deletePost(id: post.id.toString());
                },
                onEdit: () {
                  controller.editPost(post: post,);
                },
                onProfileTap: () {
                  if (Get.currentRoute == Routes.PROFILE_FEED) return;

                  if (Get.currentRoute == Routes.PAGE_FEED) return;

                  final controller = Get.put(ProfileFeedController());
                  controller.userId.value = post.user?.id.toString() ?? "";
                  controller.getProfileFeed();
                  Get.toNamed(Routes.PROFILE_FEED);
                },
              ),
            ),



           PostContentBuilder(post: post.obs, controller: controller),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
                vertical: AppDimensions.contentPadding.h,
              ),
              child: PostActions(
                post: post,
                onReaction: (reaction) {
                  ReactionManager.to.handleReaction(post: post, reaction: reaction);
                },
                onComment: () async {
                  Get.find<CommentsController>().postId = post.id!;
                  Get.find<CommentsController>().loadComments();

                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const CommentsBottomSheet(),
                  );

                  if (result != null) {
                    controller.updatePostComments(post.id ?? 0, result);
                  }
                },
                onShare: () {
                 // controller.sharePost(post);

                  Get.bottomSheet(
                    GetBuilder<SharePostController>(
                      init: SharePostController(post: post),
                      builder: (_) => const PostShareBottomSheet(),
                    ),
                    isScrollControlled: true,
                  );

                },
              ),
            ),
            const Divider(height: 24),
          ],
        ),
      );
    });
  }
}