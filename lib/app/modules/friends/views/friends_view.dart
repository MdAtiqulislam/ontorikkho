/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_list_item.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/friends_controller.dart';
import '../widgets/friend_action_button.dart';

class FriendsView extends GetView<FriendsController> {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Friends"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.refreshFriends,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                          child: SizedBox(height: AppDimensions.widgetPadding.h)),

                      _buildTopBar(),

                      // Friend Request Section
                      _buildFriendSection(
                        title: "Friend Request",
                        friends: controller.friendRequestIncoming,
                        onActionTap: _handleFriendAction,
                        onDetails: (friend) => controller.onDetails(friend: friend),
                      ),

                      // Pending Request Section
                      _buildFriendSection(
                        title: "Pending Request",
                        friends: controller.friendRequestSent,
                        onActionTap: _handleFriendAction,
                        onDetails: (friend) => controller.onDetails(friend: friend),
                      ),

                      // Suggestions Section
                      _buildFriendSection(
                        title: "People You May Know",
                        friends: controller.friendSuggestions,
                        onActionTap: _handleFriendAction,
                        onDetails: (friend) => controller.onDetails(friend: friend),
                      ),

                      if (controller.isLoadingMore.value)
                        SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),
              if (controller.isUpdating.value) LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }

  /// 🔹 Top bar with section header + search
  SliverToBoxAdapter _buildTopBar() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: AppDimensions.widgetPadding.h),
          Row(
            children: [
              Expanded(
                child: SectionHeader(title: 'Friends', showMoreButton: false),
              ),
              GestureDetector(
                onTap: controller.goToSearchPage,
                child: Container(
                  height: 40.sp,
                  width: 40.sp,
                  margin: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.search),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _buildFilterChips(),
          Divider(),
        ],
      ),
    );
  }

  /// 🔹 Horizontal filter chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FriendFilterType.values.map((type) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => controller.changeView(type: type),
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  type.label,
                  style: TextStyle(
                    color:Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ));
        }).toList(),
      ),
    );
  }

  /// 🔹 Helper for building a friend section
  SliverList _buildFriendSection({
    required String title,
    required List friends,
    required FriendActionCallback onActionTap,
    void Function(FriendsBasicInfoModel friend)? onDetails,
  })
  {
    if (friends.isEmpty) return SliverList(delegate: SliverChildListDelegate([]));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final friendItem = friends[index];
          final friendModel = friendItem.user ?? FriendsBasicInfoModel();
          final status = FriendRequestStatusExtension.fromString(
              friendModel.friendshipStatus ?? "");
          return Column(
            children: [
              if (index == 0) // Section Header at top of first item
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.widgetPadding.h),
                  child: SectionHeader(title: title, showMoreButton: false),
                ),
              FriendListItem(
                friend: friendModel,
                requestId: friendItem.id.toString(),
                mutualFriends: friendItem.mutualMembers ?? [],
                mutualFriendsCount: friendItem.mutualCount,
                status: status,
                onDetails: () => onDetails?.call(friendModel),
                onActionTap: ({
                  required action,
                  required friendId,
                  requestId,
                })
                async {
                  controller.isUpdating.value = true;
                  final result = await controller.handleFriendAction(
                    action: action,
                    friendId: friendId,
                    requestId: requestId,
                  );
                  controller.isUpdating.value = false;

                  if (result != null) {
                    friends.removeAt(index);
                    if (title == "People You May Know" &&
                        action != FriendActionType.remove) {
                      controller.getFriendRequestSent();
                    }
                  }
                },
              ),
             if(index==friends.length-1) Divider(),
            ],
          );
        },
        childCount: friends.length,
      ),
    );
  }

  /// 🔹 Centralized friend action handler
  Future<FriendActionType?> _handleFriendAction({
    required FriendActionType action,
    required String friendId,
    String? requestId,
  }) async {
    return await controller.handleFriendAction(
      action: action,
      friendId: friendId,
     requestId: requestId,
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_filter_chip.dart';
import 'package:ontorikkho/common_widgets/custom_search_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../stores/friends_store.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/extensions.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/friends_controller.dart';
import '../models/friend_basic_info_model.dart';
import '../widgets/friend_list_item.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';

class FriendsView extends GetView<FriendsController> {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Friends"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.initData,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),

                      _buildTopBar(),

                      /// 🔥 INCOMING
                      _buildSection(
                        title: "Friend Request",
                        list: FriendStore.to.incoming,
                      ),

                      /// 🔥 SENT
                      _buildSection(
                        title: "Pending Request",
                        list: FriendStore.to.sent,
                      ),

                      /// 🔥 SUGGESTIONS
                      _buildSection(
                        title: "People You May Know",
                        list: FriendStore.to.suggestions,
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

  /// 🔹 TOP BAR
  SliverToBoxAdapter _buildTopBar() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          CustomSearchBar(
            title: "Friends",
            icon: Icon(Icons.search),
            onTap: controller.goToSearchPage,
          ),
          SizedBox(height: 10.h),
          _buildFilterChips(),
          const Divider(),
        ],
      ),
    );
  }

  /// 🔹 FILTER CHIPS
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            FriendFilterType.values.map((type) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: CustomFilterChip(
                  label: type.label,
                  onTap: () => controller.changeView(type: type),
                ),
              );
            }).toList(),
      ),
    );
  }

  /// 🔥 GENERIC SECTION BUILDER
  SliverToBoxAdapter _buildSection({
    required String title,
    required RxList list,
  }) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (list.isEmpty) return const SizedBox();

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.widgetPadding.h,
              ),
              child: SectionHeader(title: title, showMoreButton: false),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (_, index) {
                final item = list[index];
                final friend = item.user ?? FriendsBasicInfoModel();

                final status = FriendRequestStatusExtension.fromString(
                  friend.friendshipStatus ?? "",
                );

                return Column(
                  children: [
                    FriendListItem(
                      friend: friend,
                      requestId: item.id.toString(),
                      mutualFriends: item.mutualMembers ?? [],
                      mutualFriendsCount: item.mutualCount,
                      status: status,

                      onDetails: () => controller.onDetails(friend: friend),

                      /// 🔥 ACTION
                      onActionTap: ({
                        required action,
                        required friendId,
                        requestId,
                      }) async {
                        await controller.handleFriendAction(
                          action: action,
                          friendId: friendId,
                          requestId: requestId,
                        );

                        /// optional UX
                        if (action == FriendActionType.remove ||
                            action == FriendActionType.block) {
                          FriendStore.to.removeSuggestion(int.parse(friendId));
                        }
                      },
                    ),

                    if (index == list.length - 1) const Divider(),
                  ],
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
