import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../controllers/two_step_verification_controller.dart';
import 'two_step_verification_intro_view.dart';
import 'two_step_verification_list_view.dart';

class TwoStepVerificationView extends GetView<TwoStepVerificationController> {
  const TwoStepVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Two-Factor Authentication",
          showTitleOnly: true,
        ),

        body: Obx(() {
          /// 🔥 FIRST CHECK → initial loading
          if (controller.initialLoading.value) {
            return const LoadingScreen(); // no flicker
          }

          /// 🔥 After loaded → build UI
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h,
                ),
                child: controller.isEnabled.value
                    ? const TwoStepVerificationListView() // Already enabled
                    : const TwoStepVerificationIntroView(), // Need to enable
              ),

              /// 🔥 Button/API loading overlay
              if (controller.isLoading.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}
