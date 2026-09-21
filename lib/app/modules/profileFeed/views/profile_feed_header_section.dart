import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/profileFeed/controllers/profile_feed_controller.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/file_circle_avater.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../common_widgets/file_option_bottom_sheet.dart';
import '../models/profile_feed_model.dart';

class ProfileFeedHeaderSection extends GetView<ProfileFeedController> {
  final ProfileDataModel profileData;
  final int totalPosts;
  final bool isOwner;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfileFeedHeaderSection({
    super.key,
    required this.profileData,
    required this.totalPosts,
    required this.isOwner,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final double coverHeight = 200.h;
    final double profileSize = 110.w;

    return SizedBox(
      width: Get.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// COVER IMAGE
          Obx(() {
            return SizedBox(
              height: coverHeight,
              width: Get.width,
              child:
                  controller.selectedCoverImage.value != null
                      ? Image.file(
                        File(controller.selectedCoverImage.value!),
                        fit: BoxFit.cover,
                      )
                      : CustomNetworkImage(
                        image: profileData.coverPhoto ?? "",
                        fit: BoxFit.cover,
                      ),
            );
          }),

          /// BACK BUTTON
          if (!controller.isOwner.value)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 12.w,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          if (controller.isOwner.value)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 12.w,
              child: GestureDetector(
                onTap: () => scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_outlined,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ),

          /// CHANGE COVER BUTTON
          if (isOwner)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 12.w,
              child: GestureDetector(
                onTap: () {
                  FileOptionBottomSheet.show(
                    onCameraTap:
                        () => controller.updateCoverPhoto(ImageSource.camera),
                    onGalleryTap:
                        () => controller.updateCoverPhoto(ImageSource.gallery),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),

          /// WHITE CARD
          Container(
            margin: EdgeInsets.only(top: coverHeight - 40),
            padding: EdgeInsets.fromLTRB(profileSize + 40.w, 16.h, 16.w, 16.h),
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadiusLarge.r),
                topRight: Radius.circular(AppDimensions.borderRadiusLarge.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  profileData.personalData?.name ?? "",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4.h),

                /// FRIENDS + POSTS
                Text(
                  "${profileData.friendList?.length ?? 0} friends • $totalPosts posts",
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),

          /// PROFILE IMAGE
          Positioned(
            top: coverHeight - (profileSize / 2),
            left: 16.w,
            child: Stack(
              children: [
                Obx(() {
                  return controller.selectedProfileImage.value != null
                      ? FileCircleAvatar(
                        width: profileSize,
                        height: profileSize,
                        border: 5,
                        bgColor: Colors.white,
                        imageFile: File(
                          controller.selectedProfileImage.value ?? "",
                        ),
                      )
                      : CustomCircleAvatar(
                        width: profileSize,
                        height: profileSize,
                        border: 5,
                        bgColor: Colors.white,
                        image: profileData.profilePicture ?? "",
                      );
                }),

                /// CAMERA ICON
                if (isOwner)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () {
                        FileOptionBottomSheet.show(
                          onCameraTap:
                              () => controller.updateProfilePicture(
                                ImageSource.camera,
                              ),
                          onGalleryTap:
                              () => controller.updateProfilePicture(
                                ImageSource.gallery,
                              ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, size: 18.sp),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
