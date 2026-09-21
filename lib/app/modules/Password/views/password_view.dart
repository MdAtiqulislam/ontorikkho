import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../common_widgets/show_hide_password_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../controllers/password_controller.dart';

class PasswordView extends GetView<PasswordController> {
   PasswordView({super.key});

  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Set Password",showNotificationButton: false,showBackButton: true,),
        body: Obx(()=>SingleChildScrollView(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                       HeaderText(
                        text: controller.isResetPassword.value?"Re-set Password":"Set Password",
                        size: 20,
                        color: AppColors.bodyText,
                      ),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      CustomTextField(
                        title: "Password",
                        hintText: "Password",
                        isPassword: !controller.showPassword.value,
                        isRequired: true,
                        controller: controller.newPasswordController,
                        validatorText: "required",
                        suffix: ShowHidePasswordButton(
                          showPassword: controller.showPassword.value,
                          onTap: () {
                            controller.showPassword.value =
                            !controller.showPassword.value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: AppDimensions.widgetPadding.h,
                      ),
                      CustomTextField(
                        title: "Confirm Password",
                        hintText: "Confirm Password",
                        isPassword: !controller.showPassword.value,
                        controller: controller.confirmPasswordController,
                        validatorText: "required",
                        isRequired: true,
                        suffix: ShowHidePasswordButton(
                          showPassword: controller.showPassword.value,
                          onTap: () {
                            controller.showPassword.value =
                            !controller.showPassword.value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      const BodyText(
                        text:
                        "Your password must be 8 digits.\nMust Contain one Capital letter, one small letter, one number & one mark.",
                        align: TextAlign.start,
                      ),
                      SizedBox(
                        height: AppDimensions.sectionPadding * 3.h,
                      ),
                      AppButton(
                        text: "Save",
                        onTap: () {
                          if(_formKey.currentState?.validate()??false){
                            controller.saveNewPassword();
                          }
                        },
                        bgColor: AppColors.primaryColor,
                      )

                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value) const LoadingScreen()
            ],
          ),
        )),
      ),
    );
  }
}
