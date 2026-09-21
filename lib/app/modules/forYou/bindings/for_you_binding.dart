import 'package:get/get.dart';

import '../controllers/for_you_controller.dart';

class ForYouBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForYouController>(
      () => ForYouController(),
    );
  }
}
