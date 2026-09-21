/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/page_feed_controller.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/file_circle_avater.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../common_widgets/file_option_bottom_sheet.dart';

class PageFeedHeaderSection extends GetView<PageFeedController> {
  final PageDataModel page;
  final int totalPosts;
  final int followerCount;
  final bool isOwner;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PageFeedHeaderSection({
    super.key,
    required this.page,
    required this.totalPosts,
    required this.followerCount,
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
                image: page.coverImage ?? "",
                fit: BoxFit.cover,
              ),
            );
          }),

          /// BACK BUTTON
          if (!isOwner || page.myRole!="admin")
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
          if (isOwner || page.myRole=="admin")
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
                  page.name ?? "",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4.h),

                /// FRIENDS + POSTS
                Text(
                  "${followerCount} followers • $totalPosts posts",
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
                    image: page.profileImage ?? "",
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
*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/page_feed_controller.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/file_circle_avater.dart';
import 'package:ontorikkho/common_widgets/file_option_bottom_sheet.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../utils/extensions.dart';

class PageFeedHeaderSection extends GetView<PageFeedController> {
  final PageDataModel page;
  final int totalPosts;
  final int followerCount;
  final bool isOwner;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PageFeedHeaderSection({
    super.key,
    required this.page,
    required this.totalPosts,
    required this.followerCount,
    required this.isOwner,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final double coverHeight = 200.h;
    final double profileSize = 110.w;

    final role = page.myRole.role;

    final canManagePage = role.canManage;
    final canEditPage = role.canEdit;

    print(role);

    return SizedBox(
      width: Get.width,
      height: coverHeight + 140.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// COVER IMAGE
          Obx(() {
            if (controller.selectedCoverImage.value != null) {
              return SizedBox(
                width: Get.width,
                height: coverHeight,
                child: Image.file(
                  File(controller.selectedCoverImage.value!),
                  fit: BoxFit.cover,
                ),
              );
            }

            return SizedBox(
              width: Get.width,
              height: coverHeight,
              child: (page.coverImage?.isNotEmpty ?? false)
                  ? CustomNetworkImage(
                image: page.coverImage!,
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey.shade300,
              ),
            );
          }),

          /// BACK / MENU BUTTON
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12.w,
            child: GestureDetector(
              onTap: () {
                if (canEditPage) {
                  scaffoldKey.currentState?.openDrawer();
                } else {
                  Get.back();
                }
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  canManagePage
                      ? Icons.menu_outlined
                      : Icons.arrow_back,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),

          /// CHANGE COVER BUTTON
          if (canManagePage)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 12.w,
              child: GestureDetector(
                onTap: () {
                  FileOptionBottomSheet.show(
                    onCameraTap: () => controller.updateCoverPhoto(
                      ImageSource.camera,
                    ),
                    onGalleryTap: () => controller.updateCoverPhoto(
                      ImageSource.gallery,
                    ),
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
          Positioned(
            top: coverHeight - 40,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                profileSize + 40.w,
                16.h,
                16.w,
                16.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:
                  Radius.circular(AppDimensions.borderRadiusLarge.r),
                  topRight:
                  Radius.circular(AppDimensions.borderRadiusLarge.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.name ?? "",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    "$followerCount followers • $totalPosts posts",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),

          /// PROFILE IMAGE
          Positioned(
            top: coverHeight - (profileSize / 2),
            left: 16.w,
            child: Stack(
              children: [
                Obx(() {
                  if (controller.selectedProfileImage.value != null) {
                    return FileCircleAvatar(
                      width: profileSize,
                      height: profileSize,
                      border: 5,
                      bgColor: Colors.white,
                      imageFile: File(
                        controller.selectedProfileImage.value!,
                      ),
                    );
                  }

                  return CustomCircleAvatar(
                    width: profileSize,
                    height: profileSize,
                    border: 5,
                    bgColor: Colors.white,
                    image: page.profileImage ?? "",
                  );
                }),

                /// CAMERA ICON
                if (canManagePage)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () {
                        FileOptionBottomSheet.show(
                          onCameraTap: () =>
                              controller.updateProfilePicture(
                                ImageSource.camera,
                              ),
                          onGalleryTap: () =>
                              controller.updateProfilePicture(
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
                        child: Icon(
                          Icons.camera_alt,
                          size: 18.sp,
                        ),
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