
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../stores/friends_store.dart';
import '../../../../utils/enums.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/friends_controller.dart';
import '../models/friend_basic_info_model.dart';
import '../widgets/friend_list_item.dart';


class PendingFriendRequestView extends GetView<FriendsController> {
  const PendingFriendRequestView({super.key});

  @override
  Widget build(BuildContext context) {

    final store = FriendStore.to; // ✅ USE STORE

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Pending Requests"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [

              RefreshIndicator(
                onRefresh: controller.getFriendRequestSent, // ❗ FIXED API
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: CustomScrollView(
                    slivers: [

                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),

                      /// 🔍 SEARCH
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Obx(() {

                            final hasText =
                                controller.sentSearch.value.isNotEmpty;

                            return Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: TextField(
                                onChanged: (v) =>
                                controller.sentSearch.value = v,

                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: hasText
                                      ? GestureDetector(
                                    onTap: () =>
                                    controller.sentSearch.value = "",
                                    child: const Icon(Icons.clear),
                                  )
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      /// 📦 LIST (STORE BASED)
                      Obx(() {

                        final list = store.sent;

                        if (list.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100.h),
                                child: Text("No pending requests"),
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {

                              final item = list[index];
                              final friend = item.user ?? FriendsBasicInfoModel();

                              final status =
                              FriendRequestStatusExtension.fromString(
                                friend.friendshipStatus ?? "",
                              );

                              return FriendListItem(
                                friend: friend,
                                requestId: item.id?.toString(),
                                mutualFriends: item.mutualMembers ?? [],
                                mutualFriendsCount: item.mutualCount,
                                status: status,

                                onDetails: () =>
                                    controller.onDetails(friend: friend),

                                onActionTap: ({
                                  required action,
                                  required friendId,
                                  requestId,
                                }) async {

                                  final result =
                                  await controller.handleFriendAction(
                                    action: action,
                                    friendId: friendId,
                                    requestId: requestId,
                                  );

                                  /// ❗ NO manual remove লাগবে না
                                  /// store auto update করবে
                                },
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

/*
class PendingFriendRequestView extends GetView<FriendsController> {
  const PendingFriendRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Pending Requests"),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.getFriendSuggestions,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
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
                            final hasText = controller.sentSearch.value.isNotEmpty;
                            return Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: TextField(
                                onChanged: (v) => controller.sentSearch.value = v,
                                controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: controller.sentSearch.value,
                                    selection: TextSelection.collapsed(
                                      offset: controller.sentSearch.value.length,
                                    ),
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search by name, area, school...",
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: hasText
                                      ? GestureDetector(
                                    onTap: () => controller.sentSearch.value = "",
                                    child: const Icon(Icons.clear),
                                  )
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // Friend List
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final friendItem = controller.friendRequestSent[index];
                            final friendModel = friendItem.user ?? FriendsBasicInfoModel();
                            final status = FriendRequestStatusExtension.fromString(
                                friendModel.friendshipStatus ?? "");
                            return FriendListItem(
                              friend: friendModel,
                              mutualFriends: friendItem.mutualMembers ?? [],
                              mutualFriendsCount: friendItem.mutualCount,
                              status: status,
                              onDetails: () => controller.onDetails(friend: friendModel),
                              onActionTap: ({
                                required action,
                                required friendId,
                                requestId,
                              }) async {
                                controller.isUpdating.value = true;
                                final result = await controller.handleFriendAction(
                                  action: action,
                                  friendId: friendId,

                                  requestId: requestId,
                                );
                                controller.isUpdating.value = false;

                                if (result != null) {
                                  controller.friendRequestSent.removeAt(index);
                                  controller.friendRequestSent.refresh();
                                }
                              },
                            );
                          },
                          childCount: controller.friendRequestSent.length,
                        ),
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
