import 'package:get/get.dart';

import '../controllers/settings_and_support_controller.dart';

class SettingsAndSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsAndSupportController>(
      () => SettingsAndSupportController(),
    );
  }
}
