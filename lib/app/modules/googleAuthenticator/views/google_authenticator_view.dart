import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/google_authenticator_controller.dart';
import 'enable_google_auth_view.dart';

class GoogleAuthenticatorView extends GetView<GoogleAuthenticatorController> {
  const GoogleAuthenticatorView({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Google Authentication",
          showBackButton: true,
          showNotificationButton: false,
        ),
        body: Obx(
              () => Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h,
                ),
                child:  const EnableGoogleAuthView(),
              ),
              if(controller.isLoading.value)LoadingScreen(),
              if(controller.isVerifying.value)LoadingScreen(),
            ],
          ),
        ),
      ),
    );

  }
}


/*return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Google Authenticator Setup"),
          centerTitle: true,
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                /// QR IMAGE
                controller.qr.value.isNotEmpty
                    ? Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Image.memory(
                    base64Decode(
                      controller.qr.value.split(",").last,
                    ),
                    width: 220,
                    height: 220,
                  ),
                )
                    : const Text("QR Not found!"),

                const SizedBox(height: 20),

                /// SECRET KEY
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          controller.secret.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: controller.secret.value),
                          );
                          Get.snackbar("Copied", "Secret key copied");
                        },
                        icon: const Icon(Icons.copy),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// OTP INPUT FIELD
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "Enter OTP from Google Authenticator",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (v) => controller.otpController.value = v,
                ),

                const SizedBox(height: 20),

                /// VERIFY & ENABLE BUTTON
                Obx(() {
                  return controller.isVerifying.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                    ),
                    onPressed: () async {
                      bool verify = await controller.verifyOtp(
                        controller.otpController.value,
                      );

                      if (!verify) {
                        Get.snackbar("Failed", "OTP is incorrect!");
                        return;
                      }

                      bool enabled = await controller.enable2fa();

                      if (enabled) {
                        Get.snackbar(
                          "Success",
                          "Two Factor Authentication Enabled!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        Get.back();
                      }
                    },
                    child: const Text(
                      "Enable 2FA",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                })
              ],
            ),
          );
        }),
      ),
    );*/