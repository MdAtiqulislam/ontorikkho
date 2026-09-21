import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../controllers/two_step_verification_controller.dart';

class TwoStepVerificationIntroView extends GetView<TwoStepVerificationController> {
  const TwoStepVerificationIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         SizedBox(height: AppDimensions.sectionPadding.h),
        Center(
          child: Icon(
            Icons.security_rounded,
            size: 120.sp,
            color: Colors.blueAccent,
          ),
        ),

         SizedBox(height: AppDimensions.sectionPadding.h),

         HeaderText(
          text: "Protect Your Account",
         size: AppDimensions.titleTextSize,
        ),

         SizedBox(height: AppDimensions.contentPadding.h),

        BodyText(
          text: "Enable Two-Factor Authentication to add an extra layer of security to your Ontorikkho account. "
              "Even if someone knows your password, they won't be able to access your account without the second verification step. "
              "You can verify using your Phone, Email, or an Authenticator App for stronger account protection.",

          maxLine: 20,
        ),



         SizedBox(height: AppDimensions.sectionPadding.h),

        Container(
          padding:  EdgeInsets.all(AppDimensions.widgetPadding.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          ),
          child:  Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: AppDimensions.contentPadding.w),
              Expanded(
                child: HeaderText(
                  text: "You will verify using Phone, Email, or Google Authenticator.",
                  maxLine: 2,
                  size: 14,
                  align: TextAlign.start,
                  fontWeight: FontWeight.normal,
                  //style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onTap:controller.enable2fa ,
                text: "Enable Now",
                bgColor: AppColors.primaryColor,
                showBorder: false,
              ),
            ),

             SizedBox(height: AppDimensions.widgetPadding.h),

            AppButton(
              onTap: controller.skip2SV,
              text:
                "Skip For Now",
              bgColor: Colors.transparent,
              textColor: Colors.grey,
              showBorder: false,
            ),
          ],
        ),
      ],
    );
  }
}
