import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ontorikkho/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:ontorikkho/app/modules/notifications/models/notifications_model.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';
import '../../../../utils/util.dart';
import '../../forYou/views/post_view/reaction_button.dart';

class SingleNotificationView extends GetView<NotificationsController> {
  final SingleNotification notification;

  const SingleNotificationView({
    super.key,
    required this.notification,
  });

  bool get isRead => notification.readAt != null;

  @override
  Widget build(BuildContext context) {
    final data = notification.data;
    final reactionType = data?.reactionType;

    /// 🔹 Safely get reaction item
    ReactionItem? reactionItem;

    if (reactionType != null && reactionType.isNotEmpty) {
      final reaction = reactionType.toReactionType();
      try {
        reactionItem =
            reactions.firstWhere((r) => r.type == reaction);
      } catch (_) {
        reactionItem = null;
      }
    }

    return Dismissible(
      key: ValueKey(notification.id),

      /// 🔥 Allow both swipe directions
      direction: DismissDirection.horizontal,

      /// 👉 Left → Right background
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 26.sp,
        ),
      ),

      /// 👉 Right → Left background
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 26.sp,
        ),
      ),

      /// 🔥 Confirm before delete
      confirmDismiss: (direction) async {
        return await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Delete Notification?"),
            content: const Text(
              "Are you sure you want to delete this notification?",
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },

      /// 🔥 On delete
      onDismissed: (direction) {
        controller.removeNotificationById(notificationId:notification.id.toString());

        Get.snackbar(
          "Deleted",
          "Notification removed",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },

      child: InkWell(
        onTap: () {
          controller.handleNotificationTap(notification);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          color: isRead ? Colors.white : const Color(0xFFE7F3FF),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 Avatar + Type Icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      (data?.userName ?? "U")
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// 🔹 Comment Icon
                  if ((data?.type)?.toLowerCase() ==
                      NotificationType.comment.value)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  /// 🔹 Reaction Lottie
                  if ((data?.type)?.toLowerCase() ==
                      NotificationType.postReaction.value &&
                      reactionItem != null)
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Lottie.asset(
                        reactionItem.asset,
                        width: 24.w,
                        height: 24.w,
                        repeat: false,
                        animate: false,
                      ),
                    ),
                ],
              ),

              SizedBox(width: 12.w),

              /// 🔹 Text Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Message
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "${data?.userName ?? "Someone"} ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: notification.message ?? "",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 6.h),

                    /// Time
                    Text(
                      notification.createdAtHuman ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}