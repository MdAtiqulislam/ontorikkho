import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/info_block.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/app_strings.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class MembershipCard extends GetView<HomeController> {
  const MembershipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
        vertical: AppDimensions.verticalPadding.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        image: DecorationImage(
          image: AssetImage(AppImagePath.membershipCardBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(),
          SizedBox(height: AppDimensions.contentPadding.h),
          _buildMiddleSection(),
          SizedBox(height: AppDimensions.contentPadding.h),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 25.sp,
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Image.asset(AppImagePath.appIcon, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 8.w),
        HeaderText(
          text: 'Ontorikkho\nClub',
          maxLine: 2,
          align: TextAlign.start,
          size: 12,
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            HeaderText(text: "STATUS", size: 8),
            HeaderText(
              text: controller.loggedInUserModel.value.status ?? "",
              size: 12,
            ),
          ],
        ),
        /* SizedBox(width: AppDimensions.contentPadding.w),
        IgnorePointer(
          ignoring: true,
          child: AppButton(
           // text: "View The Card",
            text: "My Card",
            onTap: () {},
            textTransform: TextTransform.none,
            bgColor: Colors.white,
            showBorder: false,
            textColor: Colors.black,
            fontSize: 12,
            horizontalPadding: 8.w,
            verticalPadding: 6.h,
          ),
        ),*/
      ],
    );
  }

  Widget _buildMiddleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(text: 'MEMBER NAME', size: 10),
            HeaderText(
              text: controller.loggedInUserModel.value.name ?? "",
              size: 16,
            ),
          ],
        ),
        CustomCircleAvatar(
          width: 60.sp,
          height: 60.sp,
          localImage: "assets/images/profile.png",
          image: controller.loggedInUserModel.value.profileImage ?? "",
          border: 5,
          bgColor: AppColors.borderLight,
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InfoBlock(
            title: 'Membership Expires on',
            value: controller.loggedInUserModel.value.expiredDate ?? "",
          ),
        ),
        SizedBox(width: AppDimensions.contentPadding.w),
        Expanded(
          child: InfoBlock(
            title: 'Membership Type',
            value: controller.loggedInUserModel.value.membershipType ?? "",
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}
