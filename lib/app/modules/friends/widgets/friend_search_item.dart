import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_search_controller.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_action_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../utils/enums.dart';
import '../controllers/friends_controller.dart';
import '../models/friend_button_config_factory.dart';
import '../models/search_friend_model.dart';
import '../models/friend_basic_info_model.dart';

class FriendSearchItem extends StatelessWidget {
  final SearchUser item;
  final VoidCallback? onDetails;
  final FriendActionCallback onActionTap;
  final String? requestId;

  const FriendSearchItem({
    super.key,
    required this.item,
    this.onDetails,
    required this.onActionTap,
    this.requestId,
  });

  FriendsBasicInfoModel get friend => item.user ?? FriendsBasicInfoModel();

  FriendRequestStatus? get status {
    if (item.isFriend == true) {
      return FriendRequestStatus.friend;
    }

    return FriendRequestStatusExtension.fromString(
      friend.friendshipStatus ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFriend = item.isFriend == true;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: InkWell(
        onTap: onDetails,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Avatar
            CustomCircleAvatar(
              height: 40.sp,
              width: 40.sp,
              image: item.user?.avatar ?? "",
            ),

            SizedBox(width: AppDimensions.contentPadding.w),

            /// 📄 Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name + Badge + More button row
                  Row(
                    children: [
                      /// Name
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                friend.name ?? "Unknown",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(width: 6.w),

                            /// 👇 FRIEND BADGE
                            if (isFriend)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Text(
                                  "Friend",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      /// 👉 More button (RIGHT SIDE FIXED)
                      if (isFriend)
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () async {
                            final controller = Get.find<FriendsController>();

                            final result = await controller.handleFriendAction(
                              action: FriendActionType.openMenu,
                              friend: friend,
                            );
                            if (result != null) {
                              final searchController =
                                  Get.find<FriendSearchController>();

                              searchController.updateItemStatus(
                                index: searchController.results.indexWhere(
                                  (e) => e.user?.id == friend.id,
                                ),
                                action: result,
                              );
                              /* searchController.results.removeWhere(
                                    (e) => e.user?.id == friend.id,
                              );

                              searchController.update(); // or refresh if RxList*/
                            }
                          },
                        ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  /// Subtitle
                  if ((item.member?.highestEdu ?? "").isNotEmpty)
                    Text(
                      item.member?.highestEdu ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
            ),

            /// 👉 ACTION BUTTONS (non-friend only)
            if (!isFriend) _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final config = FriendButtonConfigFactory.build(
      status: status,
      showRemoveForCanceled: false,
    );

    return FriendActionButtons(
      config: config,
      friendId: friend.id.toString(),
      requestId: requestId,
      onActionTap: ({required action, required friendId, requestId}) async {
        onActionTap(action: action, friendId: friendId, requestId: requestId);
      },
    );
  }
}
