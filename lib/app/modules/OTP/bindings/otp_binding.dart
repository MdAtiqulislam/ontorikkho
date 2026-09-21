/*import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
  }
}*/


/*
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';
import '../controllers/registration_otp_controller.dart';
import '../controllers/reset_otp_controller.dart';
import '../controllers/two_fa_otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {

    final args = Get.arguments;
    switch (args["type"]) {
      case "registration":
        Get.put<RegistrationOtpController>(
          RegistrationOtpController()
            ..email.value = args["email"]
            ..name.value = args["name"]
            ..sessionId.value = args["sessionId"],
        );
        break;

      case "reset":
        Get.put<ResetOtpController>(
          ResetOtpController()
            ..email.value = args["email"],
        );
        break;

      case "2fa":
        Get.put<TwoFaOtpController>(
          TwoFaOtpController()
            ..email.value = args["email"] ?? ""
            ..phone.value = args["phone"] ?? "",
        );
        break;
      default:
        Get.lazyPut<OtpController>(
              () => OtpController(),
        );
    }
  }
}*/


// otp_binding.dart
import 'package:get/get.dart';
import '../controllers/otp_base_controller.dart';
import '../controllers/registration_otp_controller.dart';
import '../controllers/reset_otp_controller.dart';
import '../controllers/two_fa_otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final type = args["type"];

    if (type == "registration") {
      Get.lazyPut<OtpBaseController>(() => RegistrationOtpController());
    }
    else if (type == "reset") {
      Get.lazyPut<OtpBaseController>(() => ResetOtpController());
    }
    else if (type == "2fa") {
      Get.lazyPut<OtpBaseController>(() => TwoFaOtpController());
    }
  }
}


