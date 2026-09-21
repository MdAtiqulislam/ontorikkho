import 'package:get/get.dart';

import '../controllers/two_step_verification_controller.dart';

class TwoStepVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoStepVerificationController>(
      () => TwoStepVerificationController(),
    );
  }
}
