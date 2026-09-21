import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/pageFeed/models/page_details_model.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';


class PostHeader extends StatelessWidget {
  final SinglePostModel post;
  final PageDataModel? page;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback onProfileTap;

  const PostHeader({
    super.key,
    required this.post,
    this.onDelete,
    this.onEdit,
    required this.onProfileTap,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onProfileTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CustomCircleAvatar(
            image: page?.name!=null
                ?page?.profileImage??""
                :post.user?.avatar ?? "",
            width: 40.sp,
            height: 40.sp,
          ),
          SizedBox(width: 12.sp),

          // Name & timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page?.name!=null
                      ?page?.name??""
                      :post.user?.name ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.sp),
                Text(
                  post.createdAt ?? '',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Popup Menu
         if(post.canEdit == true||post.canDelete == true) PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == 'edit') {
                if (post.canEdit == true && onEdit != null) {
                  onEdit!();
                }
              } else if (value == 'delete') {
                if (post.canDelete == true && onDelete != null) {
                  showDeleteDialog(onDelete: onDelete!);
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                enabled: post.canEdit ?? false,
                child: Row(
                  children: const [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                enabled: post.canDelete ?? false,
                child: Row(
                  children: const [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDeleteDialog({required VoidCallback onDelete}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
            vertical: AppDimensions.verticalPadding.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Warning Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerColor.withOpacity(0.1),
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
                "Delete Post?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),

              SizedBox(height: 8.h),

              /// Message
              Text(
                "This action cannot be undone. Are you sure you want to delete this post?",
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
                      onTap: () => Get.back(),
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
