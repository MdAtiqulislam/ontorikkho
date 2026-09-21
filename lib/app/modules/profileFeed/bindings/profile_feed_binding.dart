import 'package:get/get.dart';

import '../controllers/profile_feed_controller.dart';

class ProfileFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileFeedController>(
      () => ProfileFeedController(),
    );
  }
}
