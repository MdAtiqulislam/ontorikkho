
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/forYou/views/create_post_box.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_card.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_card_item.dart';
import 'package:ontorikkho/app/modules/profileFeed/controllers/profile_feed_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../stores/friends_store.dart';
import '../../../../stores/post_store.dart';
import '../../friends/controllers/friends_controller.dart';
import '../controllers/for_you_controller.dart';

class ForYouView extends GetView<ForYouController> {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Member Hub"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.refreshPosts,
                child: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    /// ================= CREATE POST =================
                    SliverToBoxAdapter(
                      child: CreatePostBox(
                        userImageUrl: controller.user.value.profileImage ?? "",
                        onCreatePostTap: () {
                          Get.toNamed(Routes.CREATE_POST);
                        },
                        onProfileTap: () {
                          final profileController =
                          Get.put(ProfileFeedController());
                          profileController.userId.value =
                              controller.user.value.userId.toString();
                          profileController.getProfileFeed();
                          Get.toNamed(Routes.PROFILE_FEED);
                        },
                      ),
                    ),

                    /// ================= FRIEND SUGGESTIONS =================
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final list = FriendStore.to.suggestions;

                        if (list.isEmpty) return const SizedBox();

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                AppDimensions.horizontalPadding.w,
                                vertical: 8,
                              ),
                              child: SectionHeader(
                                title: "People You May Know",
                                showMoreButton: true,
                                onTapViewAll: () {
                                  Get.find<FriendsController>().initData();
                                  Get.toNamed(Routes.FRIENDS);
                                },
                              ),
                            ),

                            SizedBox(
                              height: 350.sp,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                itemBuilder: (_, index) {
                                  final item = list[index];
                                  final user =
                                      item.user ?? FriendsBasicInfoModel();

                                  return FriendCardItem(
                                    friend: user,
                                    status:
                                    FriendRequestStatusExtension.fromString(
                                      user.friendshipStatus ?? "",
                                    ),
                                    mutualFriends:
                                    item.mutualMembers ?? [],
                                    mutualFriendsCount: item.mutualCount,
                                    width: 200.sp,

                                    /// 🔥 DETAILS
                                    onDetails: () {
                                      controller.onDetails(friend: user);
                                    },

                                    /// 🔥 ACTION (NO REFETCH)
                                    onActionTap: ({
                                      required action,
                                      required friendId,
                                      requestId,
                                    }) async {
                                      await Get.find<FriendsController>()
                                          .handleFriendAction(
                                        action: action,
                                        friendId: friendId,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    /// ================= POSTS =================
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final postId = controller.posts[index];
                          final post = PostStore.to.posts[postId].obs;

                        //  return Obx(()=>Text(post.value?.content??""));
                          return Obx(()=>PostCard(
                            postId: post.value?.id ?? -1,
                            controller: controller,
                          ));
                        },
                        childCount: controller.posts.length,
                      ),
                    ),

                    /// ================= LOAD MORE =================
                    if (controller.isLoadingMore.value)
                      const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),

              /// ================= GLOBAL LOADER =================
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}