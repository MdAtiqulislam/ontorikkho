/*

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/OTP/controllers/otp_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';


class RegistrationController extends GetxController {
  var isLoading = false.obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var referralController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void>signupWithEmail()async{
    isLoading.value=true;
    var endpoint=APIEndPoints.signupWithEmail;
    var body={
      "name":nameController.text,
      "email":emailController.text,
      "referral_code":referralController.text,
    };
    try {
      var res=await RemoteServices.postRequest(endpoint: endpoint,body: body);
      if(res!=null){
        CustomSnackBar(
          isSuccess: true,
          msg: res["message"]
        ).showSnackBar();

        Get.put(OtpController()).email.value=emailController.text;
        Get.find<OtpController>().sessionId.value=res["data"]["session_id"];
        Get.find<OtpController>().email.value=emailController.text;
        Get.find<OtpController>().name.value=nameController.text;
        Get.find<OtpController>().isRegistration=true;
        Get.toNamed(Routes.OTP);

      }else{
        CustomSnackBar(
            isSuccess: false,
            msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }
  }



}


*/


/*import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../OTP/controllers/otp_controller.dart';

class RegistrationController extends GetxController {
  var isLoading = false.obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var referralController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    // Load referral from LocalServices if exists
    String? ref = await LocalServices.getReferral();
    if (ref != null && ref.isNotEmpty) {
      referralController.text = ref;
    }
  }

  Future<void> signupWithEmail() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      CustomSnackBar(isSuccess: false, msg: "Name & Email required").showSnackBar();
      return;
    }

    isLoading.value = true;
    var body = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "referral_code": referralController.text.trim(),
    };

    try {
      var res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.signupWithEmail,
        body: body,
      );

      if (res != null) {
        CustomSnackBar(isSuccess: true, msg: res["message"] ?? "Signup successful").showSnackBar();

        var otpCtrl = Get.put(OtpController());
        otpCtrl.email.value = emailController.text.trim();
        otpCtrl.name.value = nameController.text.trim();
        otpCtrl.sessionId.value = res["data"]["session_id"];
        otpCtrl.isRegistration = true;

        Get.toNamed(Routes.OTP);
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      if (kDebugMode) print("Signup error: $e");
      CustomSnackBar(isSuccess: false, msg: "Something went wrong").showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }
}*/




import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';


class RegistrationController extends GetxController {
  var isLoading = false.obs;
  var disableReferCodeTf=false.obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var referralController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadReferral();
  }

  void _loadReferral() async {
    String? code = await LocalServices.getReferral();
    if (code != null) {
      referralController.text = code;
      disableReferCodeTf.value=true;
    }
  }

  Future<void> signupWithEmail() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      CustomSnackBar(isSuccess: false, msg: "Name & Email required").showSnackBar();
      return;
    }

    isLoading.value = true;
    try {
      var body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "referral_code": referralController.text.trim(),
      };

      var res = await RemoteServices.postRequest(endpoint: APIEndPoints.signupWithEmail, body: body);

      if (res != null) {
        CustomSnackBar(isSuccess: true, msg: res["message"] ?? "Signup successful").showSnackBar();

        // Clear referral
       // await LocalServices.clearReferralData();

/*        var otpCtrl = Get.put(OtpController());
        otpCtrl.email.value = emailController.text.trim();
        otpCtrl.name.value = nameController.text.trim();
        otpCtrl.sessionId.value = res["data"]["session_id"];
        otpCtrl.isRegistration = true;

        Get.toNamed(Routes.OTP);*/

        Get.toNamed(
          Routes.OTP,
          arguments: {
            "type": "registration",
            "email": emailController.text,
            "session_id":res["data"]["session_id"],
            "referral_code":referralController.text,
          },
        );

      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
