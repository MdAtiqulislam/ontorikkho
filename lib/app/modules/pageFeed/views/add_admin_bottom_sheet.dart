import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_controller.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/models/search_friend_model.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_search_item.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/manage_admin_controller.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';

class AddAdminBottomSheet extends GetView<ManageAdminController> {
  const AddAdminBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          SafeArea(
            child: SizedBox(
              height: Get.height * .9,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    /// Search
                    TextField(
                      controller: controller.searchController,
                      onChanged: (value) {
                        controller.searchText.value = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Search by name or email",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            controller.searchText.value.isEmpty
                                ? null
                                : IconButton(
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.searchText.value = "";
                                    controller.searchedFriends.clear();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius.r,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    if (controller.isSearching.value)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (controller.searchText.value.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "Search friends to add as admin",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    else if (controller.searchedFriends.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "No user found",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: controller.searchedFriends.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (_, index) {
                            final user = controller.searchedFriends[index];

                            if (user.isFriend ?? false) {
                              return _buildFriendItem(user,index);
                            }

                            return FriendSearchItem(
                              item: user,
                              requestId: user.requestId.toString(),
                              onDetails: () {
                                Get.find<FriendsController>().onDetails(
                                  friend: user.user ?? FriendsBasicInfoModel(),
                                );
                              },
                              onActionTap: ({
                                required action,
                                required friendId,
                                requestId,
                              }) async {
                                controller.isUpdating.value = true;

                                final result =
                                    await Get.find<FriendsController>()
                                        .handleFriendAction(
                                          action: action,
                                          friendId: friendId,
                                          requestId: requestId,
                                        );

                                if (result != null) {
                                  controller.updateItemStatus(
                                    index: index,
                                    action: result,
                                  );
                                }

                                controller.isUpdating.value = false;
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (controller.isUpdating.value) const LoadingScreen(),
        ],
      ),
    );
  }

  Widget _buildFriendItem(SearchUser user,int index) {

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CustomCircleAvatar(
            width: 48.sp,
            height: 48.sp,
            image: user.user?.avatar ?? "",
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              user.user?.name ?? "",
              style: AppTextStyles.header(fontSize: 15.sp),
            ),
          ),

          (user.userRole?.isEmpty ?? true)
              ? FilledButton.icon(
                onPressed: () {
                  controller.addAdmin(
                    userId: user.user?.id.toString() ?? "",
                    index: index,
                  );
                },
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text("Add"),
              )
              : _buildRoleBadge(user.userRole!),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade400),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: Colors.green.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
