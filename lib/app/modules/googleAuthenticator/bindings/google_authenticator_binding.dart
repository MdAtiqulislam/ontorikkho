import 'package:get/get.dart';

import '../controllers/google_authenticator_controller.dart';

class GoogleAuthenticatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleAuthenticatorController>(
      () => GoogleAuthenticatorController(),
    );
  }
}
