/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_controller.dart';
import 'package:ontorikkho/app/modules/profileFeed/models/profile_feed_model.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/all_posts_tab_view.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/education_section.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/personal_data_section.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/image_tab_view.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/video_tab_view.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../friends/models/friend_button_config_factory.dart';
import '../../friends/widgets/friend_action_button.dart';
import '../controllers/profile_feed_controller.dart';
import 'profile_feed_header_section.dart';

class ProfileFeedView extends StatefulWidget {
  const ProfileFeedView({super.key});

  @override
  State<ProfileFeedView> createState() => _ProfileFeedViewState();
}

class _ProfileFeedViewState extends State<ProfileFeedView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ProfileFeedController());


  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Obx(()=>Stack(
            children: [
              NestedScrollView(
                controller: controller.scrollController,
                headerSliverBuilder:
                    (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: HeaderSection(
                      profileData: controller.profileData.value,
                      totalPosts: controller.pagination.value.total ?? 0,
                      isOwnProfile: controller.isOwnProfile.value,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: PersonalDataSection(
                      personalData:
                      controller.profileData.value.personalData ??
                          PersonalDataModel(),
                      isOwnProfile: controller.isOwnProfile.value,
                    ),
                  ),
                  if(!controller.isOwnProfile.value) SliverToBoxAdapter(child: Obx(() {
                    final config = FriendButtonConfigFactory.build(
                        status: FriendRequestStatusExtension.fromString(
                            controller.friendshipStatus.value),
                        showRemoveForCanceled: false
                    );

                    return Padding(
                      padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
                      child: controller.friendshipStatus.value==FriendRequestStatus.friend.name
                          ?_buildFriendActions()
                          :FriendActionButtons(
                        config: config,
                        isLoading: controller.isLoading.value,
                        friendId:controller.userId.toString(),
                        requestId: controller.requestId.value,
                        onActionTap: ({required action, required friendId, requestId}) async {
                          controller.isUpdating.value=true;
                          var result= await Get.find<FriendsController>().handleFriendAction(
                            action: action,
                            friendId: friendId,
                            requestId: requestId,
                          );
                          controller.isUpdating.value=false;
                          if(result!=null){
                            controller.updateStatus(result);
                          }
                        },
                      ),
                    );
                  }),),
                  SliverToBoxAdapter(
                    child: EducationSection(
                      educations:
                      controller.profileData.value.education != null
                          ? [controller.profileData.value.education!]
                          : [],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      TabBar(
                        controller: tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blueAccent,
                        tabs: const [
                          Tab(text: "All Posts"),
                          Tab(text: "Photos"),
                          Tab(text: "Videos"),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  controller: tabController,
                  children: [
                    AllPostsTavView(),
                    ImageTabView(),
                    VideoTabView()
                  ],
                ),
              ),
              if(controller.isUpdating.value) LoadingScreen()
            ],
          ));
        }),
      ),
    );
  }

  _buildFriendActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(Icons.check, color: Colors.white, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                "Friends",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),

        ),
         SizedBox(width: 10.w),
        IconButton(onPressed: (){
          controller.handelOpenFriendMenu();
        }, icon: Icon(Icons.more_horiz))
      ],
    );
  }
}

/// SliverPersistentHeader Delegate for pinned TabBar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_controller.dart';
import 'package:ontorikkho/app/modules/profileFeed/models/profile_feed_model.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/all_posts_tab_view.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/education_section.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/personal_data_section.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/image_tab_view.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/profile_drawer.dart';
import 'package:ontorikkho/app/modules/profileFeed/views/video_tab_view.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../forYou/views/create_post_box.dart';
import '../../friends/models/friend_button_config_factory.dart';
import '../../friends/widgets/friend_action_button.dart';
import '../controllers/profile_feed_controller.dart';
import 'profile_feed_header_section.dart';

class ProfileFeedView extends StatefulWidget {
  const ProfileFeedView({super.key});

  @override
  State<ProfileFeedView> createState() => _ProfileFeedViewState();
}

class _ProfileFeedViewState extends State<ProfileFeedView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ProfileFeedController());

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  /// ================= FRIEND ACTION HANDLER =================
  Future<void> _handleFriendAction({
    required FriendActionType action,
    required String friendId,
    String? requestId,
  }) async {
    controller.isUpdating.value = true;

    var result = await Get.find<FriendsController>().handleFriendAction(
      action: action,
      friendId: friendId,
      requestId: requestId,
    );

    controller.isUpdating.value = false;

    if (result != null) {
      controller.updateStatus(result);
    }
  }

  /// ================= BLOCKED UI =================
  Widget _buildBlockedUI() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.block, color: Colors.red, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  "Blocked",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _handleFriendAction(
                action: FriendActionType.unblock,
                friendId: controller.userId.toString(),
              );
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }

  /// ================= FRIEND UI =================
  Widget _buildFriendActions() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  "Friends",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.handelOpenFriendMenu,
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }

  /// ================= MAIN FRIEND SECTION =================
  Widget _buildFriendSection() {
    final status = controller.friendshipStatus.value;

    if (status == FriendRequestStatus.friend.name) {
      return _buildFriendActions();
    }

    if (status == "blocked") {
      return _buildBlockedUI();
    }

    final config = FriendButtonConfigFactory.build(
      status: FriendRequestStatusExtension.fromString(status),
      showRemoveForCanceled: false,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: FriendActionButtons(
        config: config,
        isLoading: controller.isUpdating.value,
        friendId: controller.userId.toString(),
        requestId: controller.requestId.value,
        onActionTap: _handleFriendAction,
      ),
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: ProfileDrawer(),
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              NestedScrollView(
                controller: controller.scrollController,
                headerSliverBuilder:
                    (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: ProfileFeedHeaderSection(
                          profileData: controller.profileData.value,
                          totalPosts: controller.pagination.value.total ?? 0,
                          isOwner: controller.isOwner.value,
                          scaffoldKey: scaffoldKey,
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: PersonalDataSection(
                          personalData:
                              controller.profileData.value.personalData ??
                              PersonalDataModel(),
                          isOwnProfile: controller.isOwner.value,
                        ),
                      ),

                      if (!controller.isOwner.value)
                        SliverToBoxAdapter(
                          child: Obx(() => _buildFriendSection()),
                        ),

                      SliverToBoxAdapter(
                        child: EducationSection(
                          educations:
                              controller.profileData.value.education != null
                                  ? [controller.profileData.value.education!]
                                  : [],
                        ),
                      ),

                      if (controller.isOwner.value)
                        SliverToBoxAdapter(
                          child: CreatePostBox(
                            userImageUrl: controller.user.profileImage ?? "",
                            onCreatePostTap: () {
                              Get.toNamed(Routes.CREATE_POST);
                            },
                            onProfileTap: () {
                              /*final profileController = Get.put(
                                ProfileFeedController(),
                              );
                              profileController.userId.value =
                                  controller.user.userId.toString();
                              profileController.getProfileFeed();
                              Get.toNamed(Routes.PROFILE_FEED);*/
                            },
                          ),
                        ),

                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          TabBar(
                            controller: tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blueAccent,
                            tabs: const [
                              Tab(text: "All Posts"),
                              Tab(text: "Photos"),
                              Tab(text: "Videos"),
                            ],
                          ),
                        ),
                      ),
                    ],
                body: TabBarView(
                  controller: tabController,
                  children: [
                    AllPostsTabView(postController: controller),
                    ImageTabView(
                      imageList: controller.profileData.value.photoList ?? [],
                      isLoading: controller.isLoading,
                      isLoadingMore: controller.isLoadingMore,
                    ),
                     VideoTabView(
                      videos: controller.profileData.value.videoList ?? [],
                       isLoading: controller.isLoading,
                       isLoadingMore: controller.isLoadingMore,
                    ),
                  ],
                ),
              ),

              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}

/// ================= TAB BAR DELEGATE =================
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
