import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/reaction_manager.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/multi_media_preview.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_action.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_header.dart';
import 'package:ontorikkho/app/modules/singlePostView/views/single_post_shimmer.dart';
import 'package:ontorikkho/common_widgets/expandable_html_widget.dart';
import 'package:ontorikkho/common_widgets/link_preview.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/stores/post_store.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import 'package:ontorikkho/utils/util.dart';
import '../../../routes/app_pages.dart';
import '../../forYou/controllers/comment_controller.dart';
import '../../forYou/views/post_comments/comment_item.dart';
import '../../profileFeed/controllers/profile_feed_controller.dart';
import '../controllers/single_post_view_controller.dart';

class SinglePostViewView extends GetView<SinglePostViewController> {
  const SinglePostViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.post.value.user?.name ?? "",
              style: AppTextStyles.header(),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const SinglePostShimmer();
          }

          return Obx(() {

            final post = PostStore.to.posts[controller.post.value.id??-1];
            if (post == null) return const SizedBox.shrink();

            var link =
                post.youtubeLink ??
                extractFirstLink(post.content ?? "");
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
                vertical: AppDimensions.verticalPadding.h,
              ),
              child: Column(
                children: [
                  PostHeader(
                    post: post,
                    onDelete: () {},
                    onEdit: () {},
                    onProfileTap: (){
                      Get.put(ProfileFeedController()).userId.value= post.user?.id.toString()??"";
                      Get.find<ProfileFeedController>().getProfileFeed();
                      Get.toNamed(Routes.PROFILE_FEED);
                    },
                  ),
                  SizedBox(height: AppDimensions.contentPadding.h),
                  ExpandableHtmlWidget(
                    htmlContent: post.content ?? "",
                  ),
                  SizedBox(height: AppDimensions.widgetPadding.h),

                  MultiMediaPreview(
                    media: post.media ?? [],
                    isList: controller.viewAll.value,
                    onViewAll: () {
                      controller.viewAll.value = !controller.viewAll.value;
                    },
                  ),
                  if ((link ?? "").isNotEmpty) LinkPreview(url: link ?? ""),

                  PostActions(
                    post: post,
                    onReaction: (reaction) {
                      ReactionManager.to.handleReaction(
                        post: post,
                        reaction: reaction,
                      );
                    },
                    onComment: () {},
                    onShare: () {},
                  ),

                  Divider(),
                  if ((post.comments ?? []).isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: post.comments?.length,
                      itemBuilder: (_, i) {
                        Get.put(CommentsController());
                        return CommentItem(
                          comment: post.comments![i],
                        );
                      },
                    ),
                ],
              ),
            );
          });
        }),
      ),
    );
  }
}
