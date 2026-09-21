// reset_otp_controller.dart
import 'package:get/get.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../Password/controllers/password_controller.dart';
import 'otp_base_controller.dart';

class ResetOtpController extends OtpBaseController {
  var email = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments ?? {};
    email.value = args["email"]??"";
  }

  @override
  Future<void> resendOTP() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.resetPasswordOTP,
        body: {"email": email.value},
      );
      if (res != null) {
        CustomSnackBar(isSuccess: true, msg: res["msg"] ?? "OTP sent").showSnackBar();
        restartTimer(180);
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
      final body = {"email": email.value, "otp": otp};
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.verifyResetPasswordOTP,
        body: body,
      );
      if (res != null) {
        isVerifying.value = true;
        CustomSnackBar(isSuccess: true, msg: res["msg"] ?? "Verified").showSnackBar();
        // Navigate to password reset screen
        await Future.delayed(const Duration(milliseconds: 300));
        Get.put(PasswordController()).isResetPassword.value=true;
        Get.find<PasswordController>().email.value=email.value;
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
