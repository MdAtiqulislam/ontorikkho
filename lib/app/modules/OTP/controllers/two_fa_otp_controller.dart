// two_fa_otp_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';
import 'otp_base_controller.dart';

class TwoFaOtpController extends OtpBaseController {
  var email = "".obs;
  var phone = "".obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments ?? {};
    email.value = args["email"]??"";
    phone.value = args["phone"]??"";
      }

  @override
  Future<void> resendOTP() async {
    // Usually for 2FA the sending endpoint may be same as verify request trigger.
    isLoading.value = true;
    try {
      final body = {
        if (email.value.isNotEmpty) "email": email.value,
        if (phone.value.isNotEmpty) "mobile": phone.value,
      };
      final res = await RemoteServices.postRequest(endpoint: APIEndPoints.getOTP2faVerify, body: body);
      if (res != null) {
        CustomSnackBar(isSuccess: true, msg: res["msg"] ?? "OTP sent").showSnackBar();
        restartTimer(90);
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(isSuccess: false, msg: e.toString()).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> verifyOTP() async {
    final otp = getOtp();
    if (otp.length < 6) {
      CustomSnackBar(
        isSuccess: false,
        msg: "Please enter 6 digit code",
      ).showSnackBar();
      return;
    }

    // Loading indicator
    if (isGoogleAuthenticator.value) {
      isVerifying.value = true;
    } else {
      isLoading.value = true;
    }

    try {
      // Google Authenticator OTP
      if (isGoogleAuthenticator.value) {
        final res = await RemoteServices.postRequest(
          endpoint: APIEndPoints.verifyGoogle2FA,
          body: {"otp": otp},
        );

        if (res != null && res["verified"] == true) {
          await LocalServices.store2FaCompletedStatus(true);
          await fetchUserData();
          Get.offAllNamed(Routes.HOME);
        } else {
          CustomSnackBar(
            isSuccess: false,
            msg: res?["msg"] ?? APIEndPoints.httpErrorMSG.value,
          ).showSnackBar();
        }
      }
      // Normal email/phone OTP
      else {
        final body = {
          "code": otp,
          if (email.value.isNotEmpty) "email": email.value,
          if (phone.value.isNotEmpty) "mobile": phone.value,
        };
        final res = await RemoteServices.postRequest(
          endpoint: APIEndPoints.verify2faOTP,
          body: body,
        );

        if (res != null) {
          isVerifying.value = true;
          await LocalServices.store2FaCompletedStatus(true);
          CustomSnackBar(
            isSuccess: true,
            msg: res["msg"] ?? "2FA enabled",
          ).showSnackBar();
          await fetchUserData();
          Get.offAllNamed(Routes.HOME);
        } else {
          wrongOTP.value = true;
          CustomSnackBar(
            isSuccess: false,
            msg: APIEndPoints.httpErrorMSG.value,
          ).showSnackBar();
        }
      }
    } catch (e) {
      wrongOTP.value = true;
      CustomSnackBar(
        isSuccess: false,
        msg: "OTP verification failed. Please try again.",
      ).showSnackBar();
    } finally {
      if (isGoogleAuthenticator.value) {
        isVerifying.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }


  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        UserDataModel  userDataModel = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.data ?? UserData());
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
