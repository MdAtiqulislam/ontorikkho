
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

class IncomingFriendRequestView extends GetView<FriendsController> {
  const IncomingFriendRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Incoming Requests"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.getFriendRequestIncoming,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),

                      /// 🔍 SEARCH (FIXED)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Obx(() {
                            searchController.text =
                                controller.incomingSearch.value;
                            searchController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                      offset: searchController.text.length),
                                );

                            return Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: TextField(
                                controller: searchController,
                                onChanged: controller.incomingSearch,
                                decoration: InputDecoration(
                                  hintText:
                                  "Search by name, area, school...",
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: controller
                                      .incomingSearch.value.isNotEmpty
                                      ? GestureDetector(
                                    onTap: () =>
                                    controller.incomingSearch.value =
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

                      /// 👥 LIST (🔥 PURE STORE BASED)
                      Obx(() {
                        final list = FriendStore.to.incoming;

                        if (list.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: const Center(
                                child: Text("No incoming requests"),
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final item = list[index];
                              final user = item.user;

                              if (user == null) return const SizedBox();

                              final status =
                              FriendRequestStatusExtension.fromString(
                                user.friendshipStatus ?? "",
                              );

                              return FriendListItem(
                                friend: user,
                                requestId: item.id.toString(),
                                mutualFriends: item.mutualMembers ?? [],
                                mutualFriendsCount: item.mutualCount,
                                status: status,
                                onDetails: () =>
                                    controller.onDetails(friend: user),
                                /// 🚀 CLEAN ACTION
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

                                  if (result != null) {
                                    final id = int.tryParse(friendId);

                                    if (id != null) {
                                      /// শুধু list clean (STORE already updated)
                                      if (result == FriendActionType.confirm ||
                                          result == FriendActionType.delete) {
                                        FriendStore.to.incoming.removeWhere(
                                                (e) => e.user?.id == id);
                                      }
                                    }
                                  }
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

              /// 🔄 LOADER
              Obx(() => controller.isUpdating.value
                  ? const LoadingScreen()
                  : const SizedBox()),
            ],
          );
        }),
      ),
    );
  }
}