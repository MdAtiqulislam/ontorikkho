
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../../common_widgets/app_button.dart';
import '../../../../../constraints/app_colors.dart';
import '../../../../../constraints/dimensions.dart';
import '../../controllers/comment_controller.dart';
import '../../models/single_comment.dart';
import 'comment_input.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';

class CommentItem extends GetView<CommentsController> {
  final SingleComment comment;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    final id = comment.id.toString();
    final avatarSize = isReply ? 25.sp : 40.sp;

    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? AppDimensions.sectionPadding.w : 0,
        top: 8.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Main Comment
          Container(
            padding: EdgeInsets.all(8.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Avatar
                CustomCircleAvatar(
                  width: avatarSize,
                  height: avatarSize,
                  image: comment.user?.avatar ?? "",
                ),

                SizedBox(width: 8.w),

                /// Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Name + Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              comment.user?.name?.isEmpty == true
                                  ? "Anonymous"
                                  : comment.user?.name ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),

                          SizedBox(width: AppDimensions.contentPadding.w),

                          Row(
                            children: [
                              const Icon(Icons.circle, size: 3),
                              SizedBox(width: 3.w),
                              Text(
                                comment.createdAt ?? "",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// Comment / Edit field
                      Obx(() {
                        if (controller.isEditing(id)) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// TextField
                                Expanded(
                                  child: TextField(
                                    controller: controller.editCtrl(id),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: "Edit comment...",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 8.w),

                                /// Save
                                IconButton(
                                  tooltip: "Save",
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 20.sp,
                                  ),
                                  onPressed: () {
                                    if (!isReply) {
                                      controller.editComment(
                                        id,
                                        controller.editCtrl(id).text,
                                      );
                                    } else {
                                      controller.editReply(
                                        id,
                                        controller.editCtrl(id).text,
                                      );
                                    }
                                    controller.stopEdit(id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }

                        return Text(
                          comment.content ?? "",
                          style: TextStyle(fontSize: 13.sp),
                        );
                      }),

                      SizedBox(height: AppDimensions.contentPadding.h),

                      /// Reply Button
                      if (!isReply)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadius.r,
                            ),
                            splashColor: Colors.blue.withOpacity(.2),
                            onTap: () => controller.toggleReply(id),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadius.r,
                                ),
                                border: Border.all(
                                  color: AppColors.buttonGrey,
                                ),
                              ),
                              child: Text(
                                "Reply",
                                style: AppTextStyles.small(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                /// Menu
               if(comment.canDelete??false) PopupMenuButton(
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: "edit", child: Text("Edit")),
                    PopupMenuItem(value: "delete", child: Text("Delete")),
                  ],
                  onSelected: (v) {
                    if (v == "edit") {
                      controller.startEdit(id, comment.content ?? "");
                    } else {
                      if (comment.canDelete == true) {
                        showDeleteDialog(
                          onDelete: () {
                            if (!isReply) {
                              controller.deleteComment(id);
                            } else {
                              controller.deleteReply(id);
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          /// Reply Input
          Obx(() {
            if (!controller.isReplyOpen(id)) {
              return const SizedBox();
            }

            return Padding(
              padding: EdgeInsets.only(left: 48.w),
              child: ReplyInputField(
                controller: controller.replyCtrl(id),
                avatar: controller.userData.value.profileImage ?? "",
                onSend: () {
                  controller.addReply(
                    id,
                    controller.replyCtrl(id).text,
                  );
                  controller.replyCtrl(id).clear();
                  controller.toggleReply(id);
                },
              ),
            );
          }),

          /// Replies
          if (comment.replies?.isNotEmpty ?? false)
            Column(
              children: comment.replies!
                  .map((r) => CommentItem(comment: r, isReply: true))
                  .toList(),
            ),
        ],
      ),
    );
  }

  void showDeleteDialog({required VoidCallback onDelete}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
            vertical: AppDimensions.verticalPadding.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerColor.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.dangerColor,
                  size: 28.sp,
                ),
              ),

              SizedBox(height: 16.h),

              /// Title
              Text(
                "Confirm Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),

              SizedBox(height: 8.h),

              /// Message
              Text(
                "Are you sure you want to delete this comment?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 20.h),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "Cancel",
                      onTap: Get.back,
                      showBorder: true,
                      bgColor: AppColors.mutedButton,
                      borderColor: AppColors.mutedButton,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: AppButton(
                      text: "Delete",
                      bgColor: AppColors.dangerColor,
                      borderColor: AppColors.dangerColor,
                      onTap: () {
                        onDelete();
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}



