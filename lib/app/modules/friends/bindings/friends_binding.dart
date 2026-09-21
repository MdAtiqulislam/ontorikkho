import 'package:get/get.dart';

import '../controllers/friends_controller.dart';
import '../controllers/friends_search_controller.dart';

class FriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsController>(
      () => FriendsController(),

    );
  }
}


class FriendSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendSearchController>(
          () => FriendSearchController(),
    );
  }
}

/*
import 'package:get/get.dart';

import '../controllers/friends_controller.dart';
import '../controllers/friends_search_controller.dart';
class FriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendsController());
    Get.lazyPut(() => FriendSearchController());
  }
}*/
