import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../stores/friends_store.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/friends_controller.dart';
import '../widgets/my_friend_item.dart';

class MyFriendsView extends GetView<FriendsController> {
  const MyFriendsView({super.key});

  @override
  Widget build(BuildContext context) {

    final store = FriendStore.to; // ✅ IMPORTANT

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "My Friends"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.getMyFriends,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: CustomScrollView(
                    slivers: [

                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),

                      /// 🔍 SEARCH + COUNT
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Obx(() {

                            final list = store.myFriends; // ✅ use store
                            final hasText = controller.myFriendsSearch.value.isNotEmpty;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// SEARCH FIELD
                                Container(
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: TextField(
                                    onChanged: (v) =>
                                    controller.myFriendsSearch.value = v,

                                    decoration: InputDecoration(
                                      hintText: "Search by name...",
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: hasText
                                          ? GestureDetector(
                                        onTap: () =>
                                        controller.myFriendsSearch.value = "",
                                        child: const Icon(Icons.clear),
                                      )
                                          : null,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 8.h),

                                /// FRIEND COUNT
                                Text(
                                  "${list.length} friends",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                      /// 👥 FRIEND LIST
                      Obx(() {
                        final list = store.myFriends;

                        if (list.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100.h),
                                child: Text("No friends found"),
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final friend = list[index];

                              return MyFriendItem(
                                friend: friend.user??FriendsBasicInfoModel(),
                                controller: controller,
                              );
                            },
                            childCount: list.length,
                          ),
                        );
                      }),

                      if (controller.isLoadingMore.value)
                        const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),

              if (controller.isUpdating.value)
                const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}


/*class MyFriendsView extends GetView<FriendsController> {
  const MyFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "My Friends"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.getMyFriends,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),

                      // Search Bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Obx(() {
                            final hasText =
                                controller.myFriendsSearch.value.isNotEmpty;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: TextField(
                                    onChanged:
                                        (v) =>
                                            controller.myFriendsSearch.value =
                                                v,
                                    controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                        text: controller.myFriendsSearch.value,
                                        selection: TextSelection.collapsed(
                                          offset:
                                              controller
                                                  .myFriendsSearch
                                                  .value
                                                  .length,
                                        ),
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Search by name...",
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon:
                                          hasText
                                              ? GestureDetector(
                                                onTap:
                                                    () =>
                                                        controller
                                                            .myFriendsSearch
                                                            .value = "",
                                                child: const Icon(Icons.clear),
                                              )
                                              : null,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                // Friend count
                                Text(
                                  "${controller.myFriends.length} friends",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                      // Friend List (Facebook style)
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final friend = controller.myFriends[index];
                          return MyFriendItem(
                            friend: friend,
                            controller: controller,
                            index: index,
                          );
                        }, childCount: controller.myFriends.length),
                      ),

                      if (controller.isLoadingMore.value)
                        const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}*/
