import 'package:get/get.dart';

import '../controllers/order_track_controller.dart';

class OrderTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderTrackController>(
      () => OrderTrackController(),
    );
  }
}
