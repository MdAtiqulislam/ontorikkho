import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';

class GoogleAuthenticatorController extends GetxController {
  var isLoading = false.obs;
  var isVerifying = false.obs;

  var secret = "".obs;
  var qr = "".obs;
  var otpValue = "".obs;

  var userData = UserData().obs;

  @override
  void onInit() {
    super.onInit();
    _initController();
  }

  Future<void> _initController() async {
    await getUserData();
    await get2faSetupData();
  }

  /// Load stored user info
  Future<void> getUserData() async {
    isLoading.value = true;
    try {
      userData.value = await LocalServices.getUserData() ?? UserData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch new secret + QR code for Google Authenticator
  Future<void> get2faSetupData() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getGoogle2FASetup);
      if (res != null) {
        secret.value = res["secret"] ?? "";
        qr.value = res["qr"] ?? "";
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Enable Google Authenticator permanently
  Future<bool> enable2fa() async {
    if (otpValue.value.length != 6) {
      CustomSnackBar(isSuccess: false, msg: "Please enter 6-digit OTP").showSnackBar();
      return false;
    }

    isVerifying.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.google2FAEnable,
        body: {
          "secret": secret.value,
          "otp": otpValue.value,
        },
      );

      if (res != null && res["status"] == true) {
        await fetchUserData();

        Get.offAndToNamed(
          Routes.OTP,
          arguments: {
            "type": "2fa",
            "phone": userData.value.mobile,
            "google_auth": "1",
          },
        );
        return true;
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: res?["msg"] ?? APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
        return false;
      }
    } finally {
      isVerifying.value = false;
    }
  }

  /// Reset Google Authenticator → Generate new QR + secret
  Future<void> resetGoogleAuth() async {
    otpValue.value = "";
    await get2faSetupData();
  }

  /// Fetch updated user data from API and store locally
  Future<void> fetchUserData() async {
    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        final userDataModel = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.data ?? UserData());
      }
    } catch (e) {
       if (kDebugMode) {
         print("Error fetching user data: $e");
       }
    }
  }
}
