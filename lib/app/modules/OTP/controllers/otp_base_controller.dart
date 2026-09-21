// otp_base_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class OtpBaseController extends GetxController {
  var isLoading = false.obs;
  var isVerifying = false.obs;
  var wrongOTP = false.obs;
  var resendOtpTime = 90.obs;
  var isGoogleAuthenticator = false.obs;


  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();

  Timer? _timer;

  List<TextEditingController> get _controllers => [c1, c2, c3, c4, c5, c6];

  @override
  void onInit() {
    super.onInit();
    startTimer();
    final args = Get.arguments ?? {};
    isGoogleAuthenticator.value =
        (args["google_auth"] ?? "0").toString() == "1";
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    super.onClose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendOtpTime.value > 0) {
        resendOtpTime.value--;
      } else {
        resendOtpTime.value = 0;
        t.cancel();
      }
      if (isVerifying.value) t.cancel();
    });
  }

  void restartTimer(int seconds) {
    resendOtpTime.value = seconds;
    startTimer();
  }

  String getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  /// Fill OTP into all boxes (for paste/autofill)
  void fillOtp(String code, {bool shouldVerify = true}) {
    final cleaned = code.trim();
    if (cleaned.isEmpty) return;

    final chars = cleaned.split('');

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].text = i < chars.length ? chars[i] : '';
    }

    // Cursor set to last filled box
    int lastIndex = (chars.length - 1).clamp(0, 5);
    final lastController = _controllers[lastIndex];
    lastController.selection = TextSelection.fromPosition(
      TextPosition(offset: lastController.text.length),
    );

    if (shouldVerify && chars.length >= 6 && !isVerifying.value) {
      verifyOTP();
    }
  }

  /// Called on each box's onChanged
  void checkOtpLength(String? value) {
    final total = getOtp();

    // যদি user paste করে, তাহলে সব boxes update হবে
    if (total.length > 1) {
      fillOtp(total, shouldVerify: false);
    }

    if (total.length >= 6 && !total.contains(RegExp(r'\s')) && !isVerifying.value) {
      verifyOTP();
    }
  }

  /// Each specific controller MUST implement
  Future<void> verifyOTP();
  Future<void> resendOTP();
}
