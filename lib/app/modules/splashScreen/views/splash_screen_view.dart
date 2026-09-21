import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/splashScreen/controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () =>
            controller.isLoading.value
                ? SizedBox.expand(
                  child: Image.asset(
                    'assets/images/splash.jpg',
                    fit: BoxFit.cover, // FULL screen, no crop
                  ),
                )
                : Container(),
      ),
    );
  }
}
