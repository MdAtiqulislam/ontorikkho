import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import '../../../../services/local_services.dart';
import '../../../routes/app_pages.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';

class TwoStepVerificationController extends GetxController {
  /// FIRST TIME loading → prevent flicker
  var initialLoading = true.obs;

  /// UI button + API loading
  var isLoading = false.obs;

  /// 2FA status
  var isEnabled = false.obs;

  /// User data
  var userData = UserData().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadInitialData();
  }

  /// Load initial user + 2FA status
  Future<void> loadInitialData() async {
    try {
      await getUserData();
      await get2faStatus();
    } finally {
      initialLoading.value = false; // UI starts AFTER this
    }
  }

  /// User data load from local
  Future<void> getUserData() async {
    try {
      userData.value = await LocalServices.getUserData() ?? UserData();
    } catch (_) {}
  }

  /// Check 2FA status
  Future<void> get2faStatus() async {
    var endpoint = APIEndPoints.get2faStatus;
    try {
      var res = await RemoteServices.getRequest(endpoint: endpoint);
      if (res != null) {
        isEnabled.value = res["data"].toString() == "1";
      }
    } catch (_) {}
  }

  /// Enable 2FA (Update backend)
  Future<void> enable2fa() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.twoFaStatusUpdate;
    var body = {
      "is_2fa_status": "1",
    };

    try {
      var res = await RemoteServices.postRequest(endpoint: endpoint, body: body);

      if (res != null) {
        await get2faStatus();
        isEnabled.value = true;
        CustomSnackBar(isSuccess: true, msg: "2FA enabled successfully")
            .showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Phone verification
  Future<void> verifyWithPhone() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getOTP2faVerify;
    var body = {"mobile": userData.value.mobile};

    try {
      var res =
      await RemoteServices.postRequest(endpoint: endpoint, body: body);
      if (res != null) {
        CustomSnackBar(isSuccess: true, msg: res["msg"]).showSnackBar();

        Get.toNamed(
          Routes.OTP,
          arguments: {
            "type": "2fa",
            "phone": userData.value.mobile,
            "google_auth": "0",
          },
        );
      } else {
        CustomSnackBar(
            isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Email verification
  Future<void> verifyWithEmail() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getOTP2faVerify;
    var body = {"email": userData.value.email};

    try {
      var res =
      await RemoteServices.postRequest(endpoint: endpoint, body: body);
      if (res != null) {
        CustomSnackBar(isSuccess: true, msg: res["msg"]).showSnackBar();

        Get.toNamed(
          Routes.OTP,
          arguments: {
            "type": "2fa",
            "email": userData.value.email,
            "google_auth":"0"
          },
        );
      } else {
        CustomSnackBar(
            isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Authenticator
  void verifyWithGoogleAuth() {
  if((userData.value.google2faSecret??"").isNotEmpty){
    Get.toNamed(
      Routes.OTP,
      arguments: {
        "type": "2fa",
        "phone": userData.value.mobile,
        "google_auth": "1",
      },
    );
  }else{
    Get.toNamed(Routes.GOOGLE_AUTHENTICATOR);
  }

  }

  /// Skip
  void skip2SV() {
    Get.offAllNamed(Routes.HOME);
  }
}
