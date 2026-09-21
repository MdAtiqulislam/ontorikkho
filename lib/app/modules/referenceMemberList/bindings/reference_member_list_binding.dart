import 'package:get/get.dart';

import '../controllers/reference_member_list_controller.dart';

class ReferenceMemberListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferenceMemberListController>(
      () => ReferenceMemberListController(),
    );
  }
}
