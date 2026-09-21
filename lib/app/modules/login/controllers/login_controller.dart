/*
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../models/logged_in_user_model.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  var showPassword = false.obs;
  var isLoading = false.obs;
  var rememberUser = false.obs;
  var loginModel = LoginModel().obs;
  var userDataModel=UserDataModel().obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void login() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.login;
    var body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      var response = await RemoteServices.postRequest(
        endpoint: endPoint,
        body: body,
      );
      if (response != null) {
        loginModel.value = LoginModel.fromJson(response);
        await LocalServices.storeToken(loginModel.value.apiToken ?? "");
        await LocalServices().storeLoggedInUser(
          loginModel.value.data ?? LoggedInUserModel(),
        );
        await getUserData();
       await handelNext();
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserData() async {
    isLoading.value=true;
    var endpoint=APIEndPoints.getUserData;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
         userDataModel.value=UserDataModel.fromJson(res);
        await LocalServices().storeUserData(userDataModel.value.data??UserData());
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> handelNext() async {
    await LocalServices.get2FaCompletedStatus().then((value){
      if(userDataModel.value.data?.is2faStatusCheck.toString()=="1" && !value){
        Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
      }else{
        if((loginModel.value.data?.subscriptionStatus??"").toLowerCase()=="pending"){
          Get.offAllNamed(Routes.SUBSCRIPRTION);
        }else{
          Get.offAllNamed(Routes.HOME);
        }
      }
    });


  }



}
*/



import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/services/notification_service.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../models/logged_in_user_model.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  var showPassword = false.obs;
  var isLoading = false.obs;
  var rememberUser = false.obs;

  var loginModel = LoginModel().obs;
  var userDataModel = UserDataModel().obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  /// LOGIN FUNCTION
  Future<void> login() async {
    isLoading.value = true;

    var body = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
    };

    try {
      var response = await RemoteServices.postRequest(
        endpoint: APIEndPoints.login,
        body: body,
      );

      if (response != null) {
        loginModel.value = LoginModel.fromJson(response);

        // Store API Token & User Data (static methods)
        await LocalServices.storeToken(loginModel.value.apiToken ?? "");
        await LocalServices.storeLoggedInUser(
          loginModel.value.data ?? LoggedInUserModel(),
        );

        // Fetch user personal data
        await fetchUserData();

        // Decide next route
        await handleNext();
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH USER PERSONAL DATA
  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      var res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        userDataModel.value = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.value.data ?? UserData());
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// NAVIGATION LOGIC AFTER LOGIN
  Future<void> handleNext() async {
    bool is2FACompleted = await LocalServices.get2FaCompletedStatus();

    // Clear referral after login
    await LocalServices.clearReferralData();


   await storeDeviceToken();


    if (userDataModel.value.data?.is2faStatusCheck.toString() == "1" && !is2FACompleted) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
    } else if ((loginModel.value.data?.subscriptionStatus ?? "").toLowerCase() == "pending") {
      Get.offAllNamed(Routes.SUBSCRIPRTION);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }


  /// TOGGLE PASSWORD VISIBILITY
  void togglePasswordVisibility() => showPassword.value = !showPassword.value;

  Future<void> storeDeviceToken() async{
    NotificationServices.instance.getDeviceToken().then((token) async {
      var endpoint=APIEndPoints.storeDeviceToken;
      var body={"device_token":token};
      await RemoteServices.postRequest(endpoint: endpoint,body: body);
    });
  }
}

