import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_controller.dart';
import 'package:ontorikkho/app/modules/friends/models/search_friend_model.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_search_item.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/friends_search_controller.dart';

class SearchFriendsView extends GetView<FriendSearchController> {
  const SearchFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    /// 📄 Pagination Trigger
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.loadMore();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: "Search Friends", showBackButton: true),
      body: Obx(()=>Stack(
        children: [
          Column(
            children: [
              /// 🔍 Search Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                  ),
                  child: TextField(
                    onChanged: controller.onQueryChanged,
                    decoration: InputDecoration(
                      hintText: "Search by name, area, school...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              /// 📋 Result Section
              Expanded(
                child: Obx(() {
                  /// ⏳ Initial Loading
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  /// ❌ Empty State
                  if (controller.isEmpty.value) {
                    return Center(child: Text("No friends found 😔"));
                  }

                  /// 📋 List
                  return RefreshIndicator(
                    onRefresh: controller.refreshSearch,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount:
                      controller.results.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        /// 📄 Loader (bottom)
                        if (index >= controller.results.length) {
                          return Padding(
                            padding: EdgeInsets.all(12.h),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final SearchUser friend = controller.results[index];
                        return FriendSearchItem(
                          item: friend,
                          requestId: friend.requestId.toString(),
                          onDetails: () {
                            Get.find<FriendsController>().onDetails(
                              friend: friend.user ?? FriendsBasicInfoModel(),
                            );
                          },
                          onActionTap: ({
                            required action,
                            required friendId,
                            requestId,
                          }) async {
                            controller.isUpdating.value = true;
                            await Get.find<FriendsController>().handleFriendAction(
                              action: action,
                              friendId: friendId,
                              requestId: requestId,
                            ).then((result){
                              if (result != null) {
                                controller.updateItemStatus(
                                  index: index,
                                  action: result,
                                );
                              }
                              controller.isUpdating.value = false;
                            });

                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
          if(controller.isUpdating.value)LoadingScreen()
        ],
      )),
    );
  }
}
