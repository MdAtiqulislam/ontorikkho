import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/subscription/views/complete_submission.dart';
import 'package:ontorikkho/app/modules/subscription/views/user_info_form.dart';
import '../../../../common_widgets/auth_scaffold.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../controllers/subscriprtion_controller.dart';
import 'other_info_form.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          AuthScaffold(
            onBackPress: () {
              if (controller.pageIndex.value > 0) {
                controller.pageIndex.value--;
                controller.scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              } else {
                Get.back();
              }
            },

            scrollController: controller.scrollController,
            title: "Welcome to Ontorikkho",
            subtitle:
                "Please provide following information to complete your registration.",
            showBackButton: true,
            imageAlign: Alignment.center,
            child:
                controller.pageIndex.value == 0
                    ? UserInfoForm()
                    : controller.pageIndex.value == 1
                    ? OtherInfoForm()
                    : CompleteSubmission(),
          ),
          if (controller.isLoading.value) LoadingScreen(),
        ],
      ),
    );
  }

}
