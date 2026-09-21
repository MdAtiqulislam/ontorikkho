/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../utils/enums.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/friends_controller.dart';
import '../models/friend_basic_info_model.dart';
import '../widgets/friend_list_item.dart';

class FriendSuggestionsView extends GetView<FriendsController> {
  const FriendSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Friend Suggestions"),
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
                            final hasText = controller.suggestionSearch.value.isNotEmpty;
                            return Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: TextField(
                                onChanged: (v) => controller.suggestionSearch.value = v,
                                controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: controller.suggestionSearch.value,
                                    selection: TextSelection.collapsed(
                                      offset: controller.suggestionSearch.value.length,
                                    ),
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search by name, area, school...",
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: hasText
                                      ? GestureDetector(
                                    onTap: () => controller.suggestionSearch.value = "",
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
                            final friendItem = controller.friendSuggestions[index];
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
                                  controller.friendSuggestions.removeAt(index);
                                  controller.friendSuggestions.refresh();
                                  if (action != FriendActionType.remove) {
                                    controller.getFriendRequestSent();
                                  }
                                }
                              },
                            );
                          },
                          childCount: controller.friendSuggestions.length,
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

class FriendSuggestionsView extends GetView<FriendsController> {
  const FriendSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Friend Suggestions"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.getFriendSuggestions,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: CustomScrollView(
                    slivers: [

                      /// spacing
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),

                      /// ================= SEARCH =================
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Obx(() {
                            final hasText =
                                controller.suggestionSearch.value.isNotEmpty;

                            /// keep controller in sync
                            textController.value = TextEditingValue(
                              text: controller.suggestionSearch.value,
                              selection: TextSelection.collapsed(
                                offset:
                                controller.suggestionSearch.value.length,
                              ),
                            );

                            return Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: TextField(
                                controller: textController,
                                onChanged: (v) =>
                                controller.suggestionSearch.value = v,
                                decoration: InputDecoration(
                                  hintText:
                                  "Search by name, area, school...",
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: hasText
                                      ? GestureDetector(
                                    onTap: () =>
                                    controller.suggestionSearch.value =
                                    "",
                                    child: const Icon(Icons.clear),
                                  )
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      /// ================= LIST =================
                      SliverToBoxAdapter(
                        child: Obx(() {
                          final list = FriendStore.to.suggestions;

                          if (list.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 50.h),
                              child: const Center(
                                child: Text("No suggestions found"),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final item = list[index];
                              final friend =
                                  item.user ?? FriendsBasicInfoModel();

                              final status =
                              FriendRequestStatusExtension.fromString(
                                friend.friendshipStatus ?? "",
                              );

                              return FriendListItem(
                                friend: friend,
                                mutualFriends: item.mutualMembers ?? [],
                                mutualFriendsCount: item.mutualCount,
                                status: status,

                                /// DETAILS
                                onDetails: () =>
                                    controller.onDetails(friend: friend),

                                /// 🔥 ACTION (STORE DRIVEN)
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

                                  /// optional UX improvement
                                  if (action == FriendActionType.remove ||
                                      action == FriendActionType.block) {
                                    FriendStore.to.removeSuggestion(
                                        int.parse(friendId));
                                  }
                                },
                              );
                            },
                          );
                        }),
                      ),

                      if (controller.isLoadingMore.value)
                        const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),

              /// loader
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}