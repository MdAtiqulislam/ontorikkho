import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';

import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/userPersonalData/controllers/user_personal_data_controller.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/views/personal_data_shimmer.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';

import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class UserPersonalDataView extends GetView<UserPersonalDataController> {
  const UserPersonalDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        showBackButton: true,
        title: "Personal Data",
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const PersonalDataShimmer();
        }

        final user = controller.user.value.data ?? UserData();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
            vertical: AppDimensions.verticalPadding.h,
          ),
          child: CustomCard(
            horizontalPadding: AppDimensions.horizontalPadding.w,
            verticalPadding: AppDimensions.verticalPadding.h,
            child: Column(
              children: [
                _buildHeader(user),
                const Divider(height: 24),
                ..._buildInfoList(user),
                SizedBox(height: AppDimensions.sectionPadding.h),
                AppButton(
                  text: "Edit",
                  onTap: () {
                    Get.toNamed(Routes.EDIT_PROFILE);
                  },
                  bgColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(UserData user) {
    return Column(
      children: [
        CustomCircleAvatar(
          width: 80,
          height: 80,
          image: user.profileImage ?? "",
        ),
        SizedBox(height: 12.h),
        HeaderText(
          text: user.name ?? "-",
          size: 18,
        ),
        SizedBox(height: 4.h),
        BodyText(
          text: "${user.membershipType ?? ""} Member",
          color: Colors.blueGrey,
          size: 14,
        ),
      ],
    );
  }

  List<Widget> _buildInfoList(UserData user) {
    return [
      _buildInfoCard(Icons.email, "Email", user.email,/*onEdit: (){}*/),
      _buildInfoCard(Icons.phone, "Mobile", user.mobile,/*onEdit: (){}*/),
      _buildInfoCard(Icons.phone_in_talk, "Emergency Contact", user.emargencyContact),
      _buildInfoCard(Icons.person, "Gender", user.gender),
      _buildInfoCard(Icons.bloodtype, "Blood Group", user.bloodGroup),
      _buildInfoCard(Icons.location_on, "Address", user.address),
      _buildInfoCard(Icons.sports_baseball_outlined, "Sports", user.sports),
      _buildInfoCard(Icons.hotel_class_outlined, "Hobbies", user.hobbies),
      _buildInfoCard(Icons.school, "Education", user.highestEdu),
      _buildInfoCard(
        Icons.verified_user,
        "Status",
        "${user.status ?? "-"} (expires ${user.expiredDate ?? "-"})",
      ),
    ].expand((widget) => [widget, SizedBox(height: 12.h)]).toList()
      ..removeLast(); // remove last padding
  }

  Widget _buildInfoCard(
      IconData icon,
      String label,
      String? value, {
        VoidCallback? onEdit, // null হলে button hide
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColors.primaryColor.withAlpha(25),
          child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                text: label,
                size: 14,
              ),
              SizedBox(height: 4.h),
              BodyText(
                text: value ?? "-",
              ),
            ],
          ),
        ),
        // Show edit button only if onEdit is provided
        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit, size: 20.sp, color: AppColors.primaryColor),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
      ],
    );
  }

}
