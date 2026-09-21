import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';

import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          title: "Support Center",
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(()=>SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  // Background image
                  Image.asset(
                    "assets/images/contact_us_bg.png",
                    fit: BoxFit.cover,
                  ),

                  // Foreground content with transparent background
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w,
                      vertical: AppDimensions.verticalPadding.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          controller.supportData.value.title??"",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(controller.supportData.value.description??"",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.mutedText,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        _buildSupportCard(
                          icon: Icons.phone,
                          title: "Phone",
                          value: controller.supportData.value.phone??"",
                          onTap: () {
                            controller.launchPhone(controller.supportData.value.phone??"");
                          },
                        ),
                        SizedBox(height: 20.h),
                        _buildSupportCard(
                          icon: Icons.email,
                          title: "Email",
                          value: controller.supportData.value.email??"",
                          onTap: () {
                            controller.launchEmail(controller.supportData.value.email??"");
                          },
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
              if(controller.isLoading.value)LoadingScreen(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: Icon(icon, color: AppColors.primaryColor, size: 24),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.mutedText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.headerText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
