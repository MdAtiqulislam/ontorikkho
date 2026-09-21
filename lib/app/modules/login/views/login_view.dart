import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/auth_scaffold.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/common_widgets/show_hide_password_button.dart';
import 'package:ontorikkho/common_widgets/social_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/util.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/header_text.dart';
import '../../../../controllers/social_login_controller.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          AuthScaffold(
            title: "Welcome\n To Ontorikkho Club! 👋",
            subtitle: "",
            child: loginForm(),
          ),
          if (controller.isLoading.value) LoadingScreen(),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            title: "Email",
            hintText: "abc@email.com",
            preFix: Icon(Icons.email_outlined),
            validator: validateEmail,
            controller: controller.emailController,
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomTextField(
            title: "Password",
            hintText: "********",
            isPassword: !controller.showPassword.value,
            preFix: Icon(Icons.lock_outline),
            validatorText: "Required",
            controller: controller.passwordController,
            suffix: ShowHidePasswordButton(
              showPassword: controller.showPassword.value,
              onTap: () {
                controller.showPassword.value = !controller.showPassword.value;
              },
            ),
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Get.toNamed(Routes.FORGOT_PASSWORD);
              },
              child: BodyText(text: "Forgot Password?", size: 14),
            ),
          ),
          SizedBox(height: AppDimensions.widgetPadding.h),
          AppButton(
            text: "Sign in",
            onTap: () {
              //Get.offAllNamed(Routes.HOME);
              if (_formKey.currentState?.validate() ?? false) {
                controller.login();
              }
            },
            bgColor: AppColors.primaryColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderText(
                text: "Don't have an account?",
                size: 14,
                fontWeight: FontWeight.normal,
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.REGISTRATION);
                },
                child: HeaderText(
                  text: "Sign up",
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
            onAppleTap:
                Platform.isIOS
                    ? () => SocialLoginController().appleLogin()
                    : null,
          ),
        ],
      ),
    );
  }
}
