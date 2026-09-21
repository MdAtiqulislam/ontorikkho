import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/OTP/controllers/otp_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

class ForgotPasswordController extends GetxController {

  var isLoading=false.obs;
  var emailController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }



  void sendOTP() async{
    isLoading.value=true;
    var endPoint=APIEndPoints.resetPasswordOTP;
    var body={
      "email":emailController.text
    };
    try {
      var response=await RemoteServices.postRequest(endpoint: endPoint,body: body);
      if(response!=null){
       /* Get.put(OtpController()).email.value=emailController.text;
        Get.find<OtpController>().isResetPassword=true;
        Get.find<OtpController>().isRegistration=false;
        Get.toNamed(Routes.OTP);*/

        Get.toNamed(
          Routes.OTP,
          arguments: {
            "type": "reset",
            "email": emailController.text,
            //"session_id":res["data"]["session_id"],
            //"referral_code":referralController.text,
          },
        );


      }else{
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
        //Get.toNamed(Routes.OTP);
      }
    } finally {
      isLoading.value=false;
    }


  }


}
