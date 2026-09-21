import 'package:get/get.dart';

import '../controllers/membership_plans_controller.dart';

class MembershipPlansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MembershipPlansController>(
      () => MembershipPlansController(),
    );
  }
}
