/*

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../appVersionCheck/app_update_controller.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';

class SplashScreenController extends GetxController {
  var isLoading = true.obs;
  var userDataModel = UserDataModel().obs;

  final AppUpdateController updateController = Get.put(AppUpdateController(), permanent: true);

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  /// INIT APP FLOW
  void _initApp() async {
    await _checkAppVersion();
    await _handleAppFlow();
  }

  /// CHECK APP UPDATE
  Future<void> _checkAppVersion() async {
    try {
      await updateController.checkForUpdate();
    } catch (e) {
      if (kDebugMode) print("Error checking app version: $e");
    }
  }

  /// MAIN APP FLOW
  Future<void> _handleAppFlow() async {
    String token = await LocalServices.getToken();

    if (token.isEmpty) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    if (kDebugMode) print("Token found: $token");

    await fetchUserData();
    await _navigateNext();
  }

  /// FETCH USER PERSONAL DATA
  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        userDataModel.value = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.value.data ?? UserData());
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// NAVIGATION LOGIC AFTER LOGIN
  Future<void> _navigateNext() async {
    bool is2FACompleted = await LocalServices.get2FaCompletedStatus();

    final data = userDataModel.value.data;

    if (data?.is2faStatusCheck.toString() == "1" && !is2FACompleted) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
    } else if ((data?.subscriptionStatus ?? "").toLowerCase() == "pending") {
      Get.offAllNamed(Routes.SUBSCRIPRTION);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
*/


/*import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../appVersionCheck/app_update_controller.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';
import '../../../../constraints/api_end_points.dart';

class SplashScreenController extends GetxController {
  var isLoading = true.obs;
  var userDataModel = UserDataModel().obs;

  final AppUpdateController updateController = Get.put(AppUpdateController(), permanent: true);

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    await _checkAppVersion();
    await _handleAppFlow();
  }

  Future<void> _checkAppVersion() async {
    try {
      await updateController.checkForUpdate();
    } catch (e) {
      if (kDebugMode) print("App version check error: $e");
    }
  }

  Future<void> _handleAppFlow() async {
    String token = await LocalServices.getToken();

    // If not logged in
    if (token.isEmpty) {
      String? referral = await LocalServices.getReferral();

      if (referral != null && referral.isNotEmpty) {
        // Referral exists → navigate to registration with referral
        Get.offAllNamed(Routes.REGISTRATION);
        return;
      } else {
        // No referral → go to login
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    }

    // If logged in → fetch user data
    await _fetchUserData();
    await _navigateNext();
  }

  Future<void> _fetchUserData() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        userDataModel.value = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.value.data ?? UserData());
      }
    } catch (e) {
      if (kDebugMode) print("Fetch user data error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _navigateNext() async {
    bool is2FACompleted = await LocalServices.get2FaCompletedStatus();
    final data = userDataModel.value.data;

    if (data?.is2faStatusCheck.toString() == "1" && !is2FACompleted) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
    } else if ((data?.subscriptionStatus ?? "").toLowerCase() == "pending") {
      Get.offAllNamed(Routes.SUBSCRIPRTION);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}*/


import 'package:get/get.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../appVersionCheck/app_update_controller.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';
import '../../../../constraints/api_end_points.dart';

class SplashScreenController extends GetxController {
  var isLoading = true.obs;
  var userDataModel = UserDataModel().obs;

  final AppUpdateController updateController =
  Get.put(AppUpdateController(), permanent: true);

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    await updateController.checkForUpdate(); // Persistent overlay
    await _handleAppFlow();
  }

  Future<void> _handleAppFlow() async {
    String token = await LocalServices.getToken();

    if (token.isEmpty) {
      String? referral = await LocalServices.getReferral();

      if (referral != null && referral.isNotEmpty) {
        Get.offAllNamed(Routes.REGISTRATION);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
      return;
    }

    await _fetchUserData();
    await _navigateNext();
  }

  Future<void> _fetchUserData() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getUserData);
      if (res != null) {
        userDataModel.value = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.value.data ?? UserData());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _navigateNext() async {
    bool is2FACompleted = await LocalServices.get2FaCompletedStatus();
    final data = userDataModel.value.data;

    if (data?.is2faStatusCheck.toString() == "1" && !is2FACompleted) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
    } else if ((data?.subscriptionStatus ?? "").toLowerCase() == "pending") {
      Get.offAllNamed(Routes.SUBSCRIPRTION);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
