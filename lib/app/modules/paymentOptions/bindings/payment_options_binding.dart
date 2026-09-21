import 'package:get/get.dart';

import '../controllers/payment_options_controller.dart';

class PaymentOptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentOptionsController>(
      () => PaymentOptionsController(),
    );
  }
}
