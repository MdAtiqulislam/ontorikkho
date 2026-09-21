// registration_otp_controller.dart
import 'package:get/get.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../Password/controllers/password_controller.dart';
import 'otp_base_controller.dart';

class RegistrationOtpController extends OtpBaseController {
  var email = "".obs;
  var name = "".obs;
  var sessionId = "".obs;
  var referralCode="";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments ?? {};
    email.value = args["email"]??"";
    name.value = args["name"]??"";
    sessionId.value=args["session_id"]??"";
    referralCode=args["referral_code"];
  }


  @override
  Future<void> resendOTP() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.signupWithEmail,
        body: {"email": email.value, "name": name.value},
      );
      if (res != null) {
        final snackMsg = res["message"] ?? res["msg"] ?? "OTP sent";
        CustomSnackBar(isSuccess: true, msg: snackMsg).showSnackBar();
        // update session if provided
        if (res["data"] != null && res["data"]["session_id"] != null) {
          sessionId.value = res["data"]["session_id"].toString();
        }
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
      CustomSnackBar(isSuccess: false, msg: "Please enter 6 digit code").showSnackBar();
      return;
    }

    isLoading.value = true;
    try {
      final body = {"otp": otp, "session_id": sessionId.value};
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.signupWithEmailOtpVerify,
        body: body,
      );
      if (res != null) {
        isVerifying.value = true;
        CustomSnackBar(isSuccess: true, msg: res["msg"] ?? "Verified").showSnackBar();
        // Navigate to password creation (same as earlier flow)
        await Future.delayed(const Duration(milliseconds: 300));

        Get.put(PasswordController()).isResetPassword.value=false;
        Get.find<PasswordController>().sessionId=sessionId;
        Get.find<PasswordController>().referralCode=referralCode;
        Get.toNamed(Routes.PASSWORD);

      } else {
        wrongOTP.value = true;
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      wrongOTP.value = true;
      CustomSnackBar(isSuccess: false, msg: "OTP verification failed. Please try again.").showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }
}
