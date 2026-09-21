import 'package:get/get.dart';

import '../controllers/manage_admin_controller.dart';
import '../controllers/page_feed_controller.dart';

class PageFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageFeedController>(
      () => PageFeedController(),
    );
  }
}

class ManageAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageAdminController>(
      () => ManageAdminController(),
    );
  }
}
