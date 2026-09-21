import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:ontorikkho/utils/util.dart';
import '../controllers/two_step_verification_controller.dart';

class TwoStepVerificationListView extends GetView<TwoStepVerificationController> {
  const TwoStepVerificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: AppDimensions.sectionPadding.h),
      
          HeaderText(
            text: "Choose Verification Method",
            size: AppDimensions.titleTextSize,
          ),
      
          SizedBox(height: AppDimensions.contentPadding.h),
      
          BodyText(
            text: "Select one of the options below to enable Two-Factor Authentication and secure your account.",
            maxLine: 4,
          ),
      
          SizedBox(height: AppDimensions.sectionPadding.h),
      
          // Options List
          buildOption(
            icon: Icons.phone_android,
            title: "Phone Verification",
            subtitle: "Receive OTP on your phone: \n${formatPhone(controller.userData.value.mobile??"")}",
            onTap: controller.verifyWithPhone,
          ),
      
          SizedBox(height: AppDimensions.widgetPadding.h),
      
          buildOption(
            icon: Icons.email_outlined,
            title: "Email Verification",
            subtitle: "Receive code on your email: \n${formatEmail(controller.userData.value.email??"")}",
            onTap: controller.verifyWithEmail,
          ),
      
          SizedBox(height: AppDimensions.widgetPadding.h),
      
          buildOption(
            icon: Icons.key_rounded,
            title: "Google Authenticator",
            subtitle: "Use time-based OTP codes",
            onTap: controller.verifyWithGoogleAuth,
          ),

        ],
      ),
    );
  }

  Widget buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.widgetPadding.r),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(30),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 36.sp, color: AppColors.primaryColor),
            SizedBox(width: AppDimensions.contentPadding.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: title,
                    size: 18,
                  ),
                  SizedBox(height: 4.h),
                  BodyText(
                    text: subtitle,
                    maxLine: 2,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.black45, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
