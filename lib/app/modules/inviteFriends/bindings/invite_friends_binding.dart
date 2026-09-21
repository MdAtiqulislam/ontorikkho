import 'package:get/get.dart';

import '../controllers/invite_friends_controller.dart';

class InviteFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteFriendsController>(
      () => InviteFriendsController(),
    );
  }
}
