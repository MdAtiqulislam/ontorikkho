import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/app/modules/profileFeed/controllers/profile_feed_controller.dart';

import '../../../../constraints/dimensions.dart';
import '../../../../stores/post_store.dart';
import '../../forYou/controllers/for_you_controller.dart';
import '../../forYou/views/post_view/post_card.dart';

class AllPostsTabView extends StatelessWidget {
  final dynamic postController;
  final PageDataModel? pageDataModel;

  AllPostsTabView({
    required this.postController,
    super.key,
    this.pageDataModel,
  });

  final forYouController = Get.put(ForYouController());

  @override
  Widget build(BuildContext context) {
    if (postController.posts.isEmpty) {
      return Center(
        child: Text(
          "No posts available",
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      );
    }

    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.verticalPadding.h,
        ),
        itemCount: postController.posts.length,
        itemBuilder: (context, index) {
          final postId = postController.posts[index];
          final post = PostStore.to.posts[postId].obs;
          return PostCard(
            postId: post.value?.id ?? -1,
            controller: forYouController,
            pageDataModel: pageDataModel,
          );
        },
      ),
    );
  }
}
