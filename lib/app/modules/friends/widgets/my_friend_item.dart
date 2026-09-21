/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_controller.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/utils/enums.dart';

class MyFriendItem extends StatelessWidget {
  final FriendsBasicInfoModel friend;
  final FriendsController controller;
  final int index;

  const MyFriendItem({
    super.key,
    required this.friend,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isBlocked =
        friend.friendshipStatus == FriendRequestStatus.blocked.name;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: InkWell(
        onTap: () => controller.onDetails(friend: friend),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- Avatar ----------------
              Opacity(
                opacity: isBlocked ? .8 : 1,
                child: CustomCircleAvatar(
                  width: 40.sp,
                  height: 40.sp,
                  image: friend.avatar ?? "",
                ),
              ),

              SizedBox(width: 12.w),

              // ---------------- Name / Info ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isBlocked
                            ? Colors.blueGrey
                            : Colors.black,
                      ),
                    ),

                    if (isBlocked) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 14.sp,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Blocked",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ---------------- Normal Menu ----------------
              if (!isBlocked)
                IconButton(
                  onPressed: () async {
                    await controller
                        .handleFriendAction(
                      action: FriendActionType.openMenu,
                      friend: friend,
                    )
                        .then((value) {
                      if (value==FriendActionType.unfriend) {
                        controller.myFriends.removeAt(index);
                      }
                    });
                  },
                  icon: const Icon(Icons.more_horiz),
                ),

              // ---------------- Unblock Button ----------------
              if (isBlocked)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () async {
                      await controller
                          .handleFriendAction(
                        action: FriendActionType.unblock,
                        friendId: friend.id.toString(),
                      )
                          .then((value) {
                        if (value != null) {
                          final updated = friend.copyWith(
                            friendshipStatus:
                            FriendRequestStatus.friend.name,
                          );
                          controller.myFriends[index] = updated;
                        }
                      });
                    },
                    child: Text(
                      "Unblock",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/stores/friends_store.dart';

import '../controllers/friends_controller.dart';

class MyFriendItem extends StatelessWidget {
  final FriendsBasicInfoModel friend;
  final FriendsController controller;

  const MyFriendItem({
    super.key,
    required this.friend,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final store = FriendStore.to;

    return Obx(() {
      final liveFriend =
          store.getFriend(friend.id ?? 0)?.user ?? friend;

      final isBlocked =
          liveFriend.friendshipStatus == FriendRequestStatus.blocked.name;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => controller.onDetails(friend: friend),
          child: Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                /// 🔹 Avatar
                _buildAvatar(liveFriend, isBlocked),

                SizedBox(width: 12.w),

                /// 🔹 Name + Status
                Expanded(
                  child: _buildNameSection(liveFriend, isBlocked),
                ),

                /// 🔹 Action Area
                _buildAction(liveFriend, isBlocked),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// ---------------- Avatar ----------------
  Widget _buildAvatar(FriendsBasicInfoModel user, bool blocked) {
    return Opacity(
      opacity: blocked ? 0.7 : 1,
      child: CustomCircleAvatar(
        width: 42.sp,
        height: 42.sp,
        image: user.avatar ?? "",
      ),
    );
  }

  /// ---------------- Name + Status ----------------
  Widget _buildNameSection(FriendsBasicInfoModel user, bool blocked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: blocked ? Colors.blueGrey : Colors.black,
          ),
        ),

        if (blocked) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.lock_outline,
                  size: 13.sp, color: Colors.blueGrey),
              SizedBox(width: 4.w),
              Text(
                "Blocked",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// ---------------- Action ----------------
  Widget _buildAction(
      FriendsBasicInfoModel user, bool blocked) {
    if (blocked) {
      return _buildUnblockButton(user);
    }

    return IconButton(
      onPressed: () async {
        await controller.handleFriendAction(
          action: FriendActionType.openMenu,
          friend: user,
        );
      },
      icon: Icon(Icons.more_horiz, size: 20.sp),
    );
  }

  /// ---------------- Unblock Button ----------------
  Widget _buildUnblockButton(FriendsBasicInfoModel user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade400,
            Colors.blueGrey.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () async {
            await controller.handleFriendAction(
              action: FriendActionType.unblock,
              friendId: user.id.toString(),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 6.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_open,
                    size: 14.sp, color: Colors.white),
                SizedBox(width: 4.w),
                Text(
                  "Unblock",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}