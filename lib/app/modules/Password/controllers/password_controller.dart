import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';

class PasswordController extends GetxController {

  var isResetPassword=false.obs;
  var email="".obs;

  var isLoading=false.obs;
  var showPassword=false.obs;
  var newPasswordController =TextEditingController();
  var confirmPasswordController=TextEditingController();
  var sessionId="".obs;
  var referralCode="";




  @override
  void onInit() {
    super.onInit();
  }


  Future<void> setPassword() async {
    isLoading.value=true;
    var body={
      "password":newPasswordController.text,
      "password_confirmation":confirmPasswordController.text,
      "session_id":sessionId.value,
      "referral_code":referralCode??"",
    };
    var endPoint=APIEndPoints.setPassword;
    try {
      var response=await RemoteServices.postRequest(endpoint: endPoint,body: body);
      if(response!=null){
        final snackMsg = response["message"] ?? response["msg"] ?? "Something went wrong";
        Get.offAllNamed(Routes.LOGIN);
        CustomSnackBar(
            isSuccess: true,
            msg: snackMsg
        ).showSnackBar();

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

  Future<void> resetPassword() async {
    isLoading.value=true;
    var body={
      "email":email.value,
      "password":newPasswordController.text,
      "password_confirmation":confirmPasswordController.text
    };
    var endPoint=APIEndPoints.resetPassword;
    try {
      var response=await RemoteServices.postRequest(endpoint: endPoint,body: body);
      if(response!=null){
        CustomSnackBar(
            isSuccess: true,
            msg: response["msg"]
        ).showSnackBar();
        Get.offAllNamed(Routes.LOGIN);


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

  void saveNewPassword() {
    if(isResetPassword.value){
      resetPassword();
    }else{
      setPassword();
    }

  }

}
