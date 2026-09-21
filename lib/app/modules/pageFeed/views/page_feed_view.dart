import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/createPost/controllers/create_post_controller.dart';
import 'package:ontorikkho/app/modules/pageFeed/views/page_feed_header_section.dart';
import 'package:ontorikkho/app/modules/pageFeed/views/page_feed_drawer.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../forYou/views/create_post_box.dart';
import '../../profileFeed/views/all_posts_tab_view.dart';
import '../../profileFeed/views/image_tab_view.dart';
import '../../profileFeed/views/video_tab_view.dart';
import '../controllers/page_feed_controller.dart';

class PageFeedView extends StatefulWidget {
  const PageFeedView({super.key});

  @override
  State<PageFeedView> createState() => _PageFeedViewState();
}

class _PageFeedViewState extends State<PageFeedView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(PageFeedController());
  late TabController tabController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavigationBar(),
        drawer: PageFeedDrawer(
        ),
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
                        child: PageFeedHeaderSection(
                          page: controller.pageData.value,
                          totalPosts: controller.pagination.value.total ?? 0,
                          followerCount: controller.followerCount.value,
                          isOwner: controller.pageData.value.isOwner ?? false,
                          scaffoldKey: scaffoldKey,
                        ),
                      ),

                      /*

                  SliverToBoxAdapter(
                    child: PersonalDataSection(
                      personalData:
                      controller.profileData.value.personalData ??
                          PersonalDataModel(),
                      isOwnProfile: controller.isOwnProfile.value,
                    ),
                  ),

                  if (!controller.isOwnProfile.value)
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
                       */
                      if (controller.pageData.value.isOwner ?? false)
                        SliverToBoxAdapter(
                          child: CreatePostBox(
                            userImageUrl:
                                controller.pageData.value.profileImage ?? "",
                            onCreatePostTap: () {
                              final createPostController =
                                  Get.isRegistered<CreatePostController>()
                                      ? Get.find<CreatePostController>()
                                      : Get.put(CreatePostController());

                              createPostController.postProfileType =
                                  PostProfileType.pagePost;
                              createPostController.pageDetails =
                                  controller.pageData;
                              Get.toNamed(Routes.CREATE_POST);
                            },
                            onProfileTap: () {},
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
                            onTap: (id) {
                              if (id == 1 && controller.pageImages.isEmpty) {
                                controller.getPageImages(id: id);
                              }
                              if (id == 2 && controller.pageVideos.isEmpty) {
                                controller.getPageVideos(id: id);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          AllPostsTabView(
                            postController: controller,
                            pageDataModel: controller.pageData.value,
                          ),
                          ImageTabView(
                            imageList: controller.pageImages,
                            isLoading: controller.isLoadingMedia,
                            isLoadingMore: controller.isLoadingMoreImages,
                          ),
                          VideoTabView(
                            videos: controller.pageVideos,
                            isLoading: controller.isLoadingMedia,
                            isLoadingMore: controller.isLoadingMoreVideos,
                          ),
                        ],
                      ),
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
