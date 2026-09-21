
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ontorikkho/app/modules/registration/controllers/registration_controller.dart';
import 'package:ontorikkho/controllers/social_login_controller.dart';
import 'package:ontorikkho/utils/util.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../common_widgets/social_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';

class RegistrationWithEmail extends GetView<RegistrationController> {
   RegistrationWithEmail({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            title: "Email",
            hintText: "Enter your email",
            isRequired: true,
            validator: validateEmail,
            controller: controller.emailController,
            preFix: Icon(Icons.email_outlined),
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomTextField(
            title: "Name",
            hintText: "Enter your full name",
            isRequired: true,
            validatorText: "Required",
            controller: controller.nameController,
            preFix: Icon(Icons.person),
          ),

          SizedBox(height: AppDimensions.contentPadding.h),
         Obx(()=> CustomTextField(
           title: "Referral Code (Optional)",
           hintText: "Enter Referral Code",
           isRequired: false,
           isEnable: !controller.disableReferCodeTf.value,
           //validatorText: "Required",
           controller: controller.referralController,
           preFix: Icon(Icons.person),
         ),),


          SizedBox(height: AppDimensions.widgetPadding.h),
          AppButton(
            text: "Next",
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                controller.signupWithEmail();
              }
            },
            bgColor: AppColors.primaryColor,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderText(
                text: "Already have an account?",
                size: 14,
                fontWeight: FontWeight.normal,
              ),
              TextButton(
                onPressed: () {
                  Get.offAndToNamed(Routes.LOGIN);
                },
                child: HeaderText(
                  text: "Sign in",
                  color: AppColors.primaryColor,
                  size: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.widgetPadding.h),

          SocialButtons(
            onGoogleTap: () {
              SocialLoginController().googleLogin();
            },
            onFacebookTap: () {
              SocialLoginController().facebookLogin();
            },
            onAppleTap: Platform.isIOS ? () =>  SocialLoginController().appleLogin() : null,
          ),
          SizedBox(height: AppDimensions.sectionPadding),
        ],
      ),
    );
  }
}
