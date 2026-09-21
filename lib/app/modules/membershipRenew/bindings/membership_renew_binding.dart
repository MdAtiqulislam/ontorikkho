import 'package:get/get.dart';

import '../controllers/membership_renew_controller.dart';

class MembershipRenewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MembershipRenewController>(
      () => MembershipRenewController(),
    );
  }
}
