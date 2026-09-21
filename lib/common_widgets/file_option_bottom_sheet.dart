import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import 'custom_bottom_sheet.dart';

class FileOptionBottomSheet extends StatelessWidget {

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final String title;

  const FileOptionBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    this.title = "Select an action",
  });

  static void show({
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    String title = "Select an action",
  }) {
    showCustomBottomSheet(
      title: title,
      content: FileOptionBottomSheet(
        onCameraTap: onCameraTap,
        onGalleryTap: onGalleryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Camera Option
        _buildOption(
          iconPath: AppImagePath.cameraIcon,
          text: "Open Camera",
          subText: "Capture an image using your camera",
          onTap: () {
            Get.back();
            onCameraTap();
          },
        ),

        const Divider(),

        /// Gallery Option
        _buildOption(
          iconPath: AppImagePath.galleryIcon,
          text: "Choose File",
          subText: "Select file from gallery",
          onTap: () {
            Get.back();
            onGalleryTap();
          },
        ),
      ],
    );
  }

  Widget _buildOption({
    required String iconPath,
    required String text,
    required String subText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Row(
              children: [

                Image.asset(iconPath, height: 30.h),

                SizedBox(width: 16.w),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    HeaderText(text: text),

                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: BodyText(
                        text: subText,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}