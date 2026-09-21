import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../../utils/util.dart';
import '../../../routes/app_pages.dart';
import '../../Password/controllers/password_controller.dart';
import '../../login/models/login_model.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;
  var isValidate = false.obs;
  var wrongOTP = false.obs;
  var resendOtpTime = 90.obs;
  var otp = "";
  var loginModel = LoginModel();

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();

  Timer? timer;

  var isRegistration = false;
  var isLogin = false;
  var isResetPassword = false;
  var email = "".obs;
  var phone = "".obs;
  var name = "".obs;
  var sessionId="".obs;

  @override
  Future<void> onInit() async {
    updateStatusBar();
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {}

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTime.value > 0) {
        resendOtpTime.value--;
      }
      if (resendOtpTime.value <= 0) {
        resendOtpTime.value = 0;
        timer.cancel();
      }
      if (isValidate.value) {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
   isRegistration?resendOTPForRegistration():resendOTPForOthers();
  }


  Future<void> resendOTPForOthers() async {
    isLoading.value = true;
    const endPoint = APIEndPoints.resetPasswordOTP;
    final body = {
      "email":email.value
    };

    try {
      final response =
      await RemoteServices.postRequest(endpoint: endPoint, body: body);
      if (response != null) {
        isLoading.value = false;
        resendOtpTime.value = 180;
        startTimer();
        CustomSnackBar(
          isSuccess: true,
          msg: response["msg"],
        ).showSnackBar();
      } else {
        isLoading.value = false;
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackBar(
        isSuccess: false,
        msg: '$e',
      ).showSnackBar();
    }
  }


  Future<void> resendOTPForRegistration() async {
    isLoading.value = true;
    const endPoint = APIEndPoints.signupWithEmail;
    final body = {
      "email":email.value,
      "name":name.value
    };

    try {
      final response =
      await RemoteServices.postRequest(endpoint: endPoint, body: body);
      if (response != null) {
        final snackMsg = response["message"] ?? response["msg"] ?? "Something went wrong";
        isLoading.value = false;
        resendOtpTime.value = 90;
        sessionId.value=response["data"]["session_id"];
        startTimer();
        CustomSnackBar(
          isSuccess: true,
          msg: snackMsg,
        ).showSnackBar();
      } else {
        isLoading.value = false;
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackBar(
        isSuccess: false,
        msg: '$e',
      ).showSnackBar();
    }
  }




  void checkOtpLength(String? value) {
    if ((value ?? "").length >= 6) {
      for (int i = 0; i < 6; i++) {
        [c1, c2, c3, c4, c5, c6][i].text = value![i];
      }
      verifyOTP();
    }
  }

  Future<void> verifyOTP() async {
    isLoading.value = true;
    var endPoint = isResetPassword?APIEndPoints.verifyResetPasswordOTP:APIEndPoints.signupWithEmailOtpVerify;
    String otp = "${c1.text}${c2.text}${c3.text}${c4.text}${c5.text}${c6.text}";
    var body =sessionId.value.isNotEmpty? {"otp": otp,"session_id":sessionId.value}:{"otp": otp, "email": email.value};

    try {
      var response =
      await RemoteServices.postRequest(endpoint: endPoint, body: body);
      if (response != null) {
        isValidate.value = true;
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(
          isSuccess: false,
          msg: "OTP verification failed. Please try again.")
          .showSnackBar();
    } finally {
      isLoading.value = false;
    }

  }

  void handelNext() {
    if(isResetPassword){
      Get.put(PasswordController()).isResetPassword.value=true;
      Get.find<PasswordController>().email.value=email.value;
      Get.toNamed(Routes.PASSWORD);
    }else if(isRegistration){
      Get.put(PasswordController()).isResetPassword.value=false;
      Get.find<PasswordController>().sessionId=sessionId;
      Get.toNamed(Routes.PASSWORD);
    }
  }


}
