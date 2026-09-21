
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/registration/views/registration_with_email.dart';
import '../../../../common_widgets/auth_scaffold.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../controllers/registration_controller.dart';




class RegistrationView extends GetView<RegistrationController> {
   const RegistrationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Stack(
        children: [
          AuthScaffold(
            onBackPress: () {
             Get.back();
            },

            title: "Join with Ontorikkho",
            subtitle: "Apply to be a member easily.",
            //subtitle: "Please provide following information to complete your registration.",
            showBackButton: true,
            imageAlign: Alignment.center,
            child:RegistrationWithEmail()
          ),
          if (controller.isLoading.value) LoadingScreen(),
        ],
      ),
    );
  }

}
