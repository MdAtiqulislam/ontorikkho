import 'package:get/get.dart';

import '../controllers/user_personal_data_controller.dart';

class UserPersonalDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPersonalDataController>(
      () => UserPersonalDataController(),
    );
  }
}
