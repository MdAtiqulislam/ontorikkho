
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/utils/util.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';

import '../../../../constraints/header_text.dart';
import '../../../../constraints/body_text.dart';
import '../controllers/otp_base_controller.dart';
import '../views/single_otp_box.dart';
import '../../../../common_widgets/app_button.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpBaseController>();

    // ----------- NEW ARGUMENT HANDLING -----------
    final args = Get.arguments ?? {};
    final email = args["email"];
    final phone = args["phone"];
    // -----------------------------------------------

    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP"), centerTitle: true),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const HeaderText(text: "Verify your account"),
                  const SizedBox(height: 12),

                  // ---------- SHOW EMAIL OR PHONE ----------
                  BodyText(
                    text: phone != null
                        ? "To verify your identity, we've sent a 6-digit verification code to your phone number: ${formatPhone(phone)}"
                        : "To verify your identity, we've sent a 6-digit verification code to your email address: ${formatEmail(email)}",
                  ),

                  // ------------------------------------------

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SingleOTPBox(controller: controller.c1, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c2, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c3, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c4, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c5, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(
                        controller: controller.c6,
                        onCompleted: (v) {
                          controller.checkOtpLength(v);
                          //if (controller.getOtp().length >= 6) controller.verifyOTP();
                        },
                        isLast: true,
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),

                  Obx(
                        () => controller.resendOtpTime.value > 0
                        ? Text(
                      "Resend code in ${controller.resendOtpTime.value} sec",
                      style: const TextStyle(color: AppColors.primaryColor),
                    )
                        : TextButton(
                      onPressed: () => controller.resendOTP(),
                      child: const Text("Resend Code"),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                    text: "Verify",
                    onTap: () => controller.verifyOTP(),
                    bgColor: AppColors.primaryColor,
                  ),

                  const SizedBox(height: 12),

                  if (controller.wrongOTP.value)
                    const BodyText(
                      text: "OTP doesn't match. Please try again.",
                      color: Colors.red,
                    ),
                ],
              ),
            ),
        if (controller.isLoading.value) const LoadingScreen()
          ],
        );
      }),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/utils/util.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/header_text.dart';
import '../../../../constraints/body_text.dart';
import '../controllers/otp_base_controller.dart';
import '../views/single_otp_box.dart';
import '../../../../common_widgets/app_button.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpBaseController>();

    // ----------- NEW ARGUMENT HANDLING -----------
    final args = Get.arguments ?? {};
    final email = args["email"];
    final phone = args["phone"];
    // -----------------------------------------------

    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP"), centerTitle: true),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const HeaderText(text: "Verify your account"),
                  const SizedBox(height: 12),

                  // ---------- SHOW MESSAGE BASED ON TYPE ----------
                  Obx(
                        () => BodyText(
                      text: controller.isGoogleAuthenticator.value
                          ? "Enter the 6-digit OTP generated by your Google Authenticator app to verify your account."
                          : phone != null
                          ? "To verify your identity, we've sent a 6-digit verification code to your phone number: ${formatPhone(phone)}"
                          : "To verify your identity, we've sent a 6-digit verification code to your email address: ${formatEmail(email)}",
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SingleOTPBox(controller: controller.c1, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c2, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c3, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c4, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(controller: controller.c5, onCompleted: controller.checkOtpLength),
                      SingleOTPBox(
                        controller: controller.c6,
                        onCompleted: (v) => controller.checkOtpLength(v),
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ---------- RESEND OPTION ----------
                  Obx(
                        () => controller.isGoogleAuthenticator.value
                        ? const SizedBox.shrink() // Google Authenticator হলে দেখাবে না
                        : controller.resendOtpTime.value > 0
                        ? Text(
                      "Resend code in ${controller.resendOtpTime.value} sec",
                      style: const TextStyle(color: AppColors.primaryColor),
                    )
                        : TextButton(
                      onPressed: () => controller.resendOTP(),
                      child: const Text("Resend Code"),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                    text: "Verify",
                    onTap: () => controller.verifyOTP(),
                    bgColor: AppColors.primaryColor,
                  ),

                  const SizedBox(height: 12),

                  if (controller.wrongOTP.value)
                    const BodyText(
                      text: "OTP doesn't match. Please try again.",
                      color: Colors.red,
                    ),
                ],
              ),
            ),

            if (controller.isLoading.value) const LoadingScreen(),
          ],
        );
      }),
    );
  }
}
