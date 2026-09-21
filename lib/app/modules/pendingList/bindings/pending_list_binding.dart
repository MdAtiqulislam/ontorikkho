import 'package:get/get.dart';

import '../controllers/pending_list_controller.dart';

class PendingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendingListController>(
      () => PendingListController(),
    );
  }
}
