import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/info_block.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/app_strings.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class BioCard extends StatelessWidget {
  const BioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        boxShadow: [BoxShadow(blurRadius: 10.r, color: AppColors.shadowColor)],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomCircleAvatar(
                      width: 80.sp,
                      height: 80.sp,
                      border: 5,
                      localImage: "assets/images/person_5.png",
                    ),
                    SizedBox(width: AppDimensions.contentPadding.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(text: "Mr. Jewel"),
                        Row(
                          children: [
                            HeaderText(
                              text: "Membership id:",
                              size: 10,
                              fontWeight: FontWeight.normal,
                            ),
                            HeaderText(text: " 6489772", size: 10),
                          ],
                        ),
                        Row(
                          children: [
                            HeaderText(
                              text: "Status:",
                              size: 10,
                              fontWeight: FontWeight.normal,
                            ),
                            HeaderText(text: " Active", size: 10),
                            SizedBox(width: AppDimensions.contentPadding.w),
                            Icon(
                              Icons.circle,
                              color: AppColors.primaryColor,
                              size: 10.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.widgetPadding.h),
                HeaderText(text: "Bio", size: 12),
                BodyText(
                  text:
                      "Lorem ipsum dolor sit amet consectetur. Faucibus viverra ante amet elementum pretium.",
                  size: 12,
                  align: TextAlign.start,
                ),
                SizedBox(height: AppDimensions.widgetPadding.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoBlock(
                        title: "Membership type",
                        value: "Gold"),
                    InfoBlock(
                        title: "Membership Expired on",
                        value: "Dec 31, 2025",
                    crossAxisAlignment: CrossAxisAlignment.end,),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.EDIT_PROFILE);
              },
              icon: Image.asset(AppImagePath.editIcon, width: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
