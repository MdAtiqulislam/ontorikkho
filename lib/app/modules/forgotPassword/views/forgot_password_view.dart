import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/utils/util.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
   ForgotPasswordView({super.key});

  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true,showNotificationButton: false,),
        body: Obx(()=>Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeaderText(text: "Forgot Password? 🔒",
                      size: 20,
                      align: TextAlign.start,),
                    SizedBox(height: AppDimensions.contentPadding.h,),
                    BodyText(
                      text: "Enter your email and we'll send you OTP to reset your password",
                      size: 14,
                      align: TextAlign.start,),
                    SizedBox(height: AppDimensions.widgetPadding.h,),
                    emailForm(),
                  ],
                ),
              ),
            ),
            if(controller.isLoading.value)LoadingScreen()
          ],
        )),
      ),
    );
  }

  Widget emailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: "Enter your registered email",
           // levelText: "Email",
            validator: validateEmail,
            isRequired: true,
            title: "Email",
            controller: controller.emailController,
          ),

          SizedBox(height: AppDimensions.sectionPadding.h,),
          AppButton(
            text: "Send OTP",
            onTap: (){
              if(_formKey.currentState?.validate()??false){
                controller.sendOTP();
              }
            },
            bgColor: AppColors.primaryColor,
            textTransform: TextTransform.none,
          ), SizedBox(height: AppDimensions.widgetPadding.h,),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios,color: AppColors.headerText,),
                  SizedBox(width: AppDimensions.contentPadding.w,),
                  BodyText(text: "Back To Login",size: 14,fontWeight: FontWeight.bold,color: AppColors.headerText,)
                ],
              ),
              onPressed: (){
                Get.offAndToNamed(Routes.LOGIN);
              },
            ),
          )
        ],

      ),
    );
  }
}
