import 'package:get/get.dart';

import '../controllers/own_profile_controller.dart';

class OwnProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnProfileController>(
      () => OwnProfileController(),
    );
  }
}
