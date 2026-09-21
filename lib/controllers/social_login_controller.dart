/*import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../app/modules/login/models/login_model.dart';
import '../app/modules/userPersonalData/models/user_personal_data_model.dart';
import '../app/routes/app_pages.dart';
import '../models/logged_in_user_model.dart';
import '../services/local_services.dart';
import '../services/notification_service.dart';
import '../services/remote_services.dart';


class SocialLoginController extends GetxController{
  var isLoading=false.obs;

  var userDataModel = UserDataModel().obs;
  var loginModel = LoginModel().obs;

  void facebookLogin() async{
    try {
      isLoading.value=true;
      final result = await FacebookAuth.i.login(
        permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
      );
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        final endPoint=APIEndPoints.socialLoginEndpoint;
        var email=(userData.toString().contains("email"))?userData['email']:"";
        var body = {
          'facebook_id': userData['id'].toString(),
          'google_id': "",
          'apple_id': "",
          'name': userData['name'],
          'email':email,
          'phone': "",
        };

        var data=await RemoteServices.postRequest(endpoint: endPoint, body: body,);
        if(data!=null){

          loginModel.value = LoginModel.fromJson(data);
          // Store API Token & User Data (static methods)
          await LocalServices.storeToken(loginModel.value.apiToken ?? "");
          await LocalServices.storeLoggedInUser(
            loginModel.value.data ?? LoggedInUserModel(),
          );

          // Fetch user personal data
          await fetchUserData();

          // Decide next route
          await handleNext();

        }else{
          CustomSnackBar( msg:APIEndPoints.httpErrorMSG.value,isSuccess: false).showSnackBar();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      isLoading.value=false;
    }
  }

  Future<void> googleLogin() async {
    isLoading.value = true;

    try {
      // Disconnect old sessions first
      await GoogleSignIn.instance.disconnect();
      await GoogleSignIn.instance.signOut();

      // Optional: if required for web or custom clientId usage
      await GoogleSignIn.instance.initialize(
        // serverClientId: "979394384810-p87i6n3834lhrrvd3oj9avivli3s1jjb.apps.googleusercontent.com",
        clientId: "979394384810-r3lshc9rcs2kgbqrd3sd82mbkegs6en3.apps.googleusercontent.com",
      );

      final completer = Completer<GoogleSignInAccount>();

      // Listen for sign-in event
      final subscription = GoogleSignIn.instance.authenticationEvents.listen(
            (event) {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            completer.complete(event.user);
          }
        },
        onError: (error) {
          completer.completeError(Exception("Google Sign-In Error: $error"));
        },
      );

      // Trigger the sign-in prompt
      await GoogleSignIn.instance.authenticate();

      // Wait for result
      final result = await completer.future;

      if (kDebugMode) {
        print(result);
      }

      var endPoint=APIEndPoints.socialLoginEndpoint;
      var body = {
        'facebook_id':"",
        'google_id': result.id.toString(),
        'apple_id': "",
        'name': result.displayName.toString(),
        'email':result.email,
        'phone': "",
      };

      var data=await RemoteServices.postRequest(endpoint: endPoint, body: body,);
      if(data!=null){

        loginModel.value = LoginModel.fromJson(data);
        // Store API Token & User Data (static methods)
        await LocalServices.storeToken(loginModel.value.apiToken ?? "");
        await LocalServices.storeLoggedInUser(
          loginModel.value.data ?? LoggedInUserModel(),
        );

        // Fetch user personal data
        await fetchUserData();

        // Decide next route
        await handleNext();


      }else{
        CustomSnackBar( msg:APIEndPoints.httpErrorMSG.value,isSuccess: false).showSnackBar();
      }
      await FacebookAuth.instance.logOut();


      // Cleanup listener
      await subscription.cancel();

      if (kDebugMode) {
        print("Google user info: ${result.displayName}, ${result.email}");
      }


    } catch (e) {
      if (kDebugMode) {
        print("Google Login Error: $e");
      }

    } finally {
      isLoading.value = false;
    }
  }




  void appleLogin() async {
    try {
      isLoading.value = true;
      final bool isAvailable = await SignInWithApple.isAvailable();

      if (isAvailable) {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        var endPoint = APIEndPoints.socialLoginEndpoint;

        var body = {
          'facebook_id': "",
          'google_id': "",
          'apple_id': credential.userIdentifier, // Correct usage
          'name': credential.givenName ?? "",
          'email': credential.email ?? "",
          'phone': "",
        };

        var data = await RemoteServices.postRequest(endpoint: endPoint,body:  body,);
        if (data != null) {

          loginModel.value = LoginModel.fromJson(data);
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
            msg: APIEndPoints.httpErrorMSG.value,
            isSuccess: false,
          ).showSnackBar();
        }
      } else {
        CustomSnackBar(
          msg: "Apple Sign-In is not available on this device.",
          isSuccess: false,
        ).showSnackBar();
      }
    } catch (error) {
      if (kDebugMode) print("Apple login error: $error");
      CustomSnackBar(
        msg: "Something went wrong during Apple login.",
        isSuccess: false,
      ).showSnackBar();
    } finally {
      isLoading.value = false;
    }

  }

  Future<void> handleNext() async {
    isLoading.value=true;
    bool is2FACompleted = await LocalServices.get2FaCompletedStatus();

    // Clear referral after login
    await LocalServices.clearReferralData();


    await storeDeviceToken();


    if (userDataModel.value.data?.is2faStatusCheck.toString() == "1" && !is2FACompleted) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
      isLoading.value=false;
    } else if ((loginModel.value.data?.subscriptionStatus ?? "").toLowerCase() == "pending") {
      Get.offAllNamed(Routes.SUBSCRIPRTION);
      isLoading.value=false;
    } else {
      Get.offAllNamed(Routes.HOME);
      isLoading.value=false;
    }
  }

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

  Future<void> storeDeviceToken() async{
    NotificationServices.instance.getDeviceToken().then((token) async {
      var endpoint=APIEndPoints.storeDeviceToken;
      var body={"device_token":token};
      await RemoteServices.postRequest(endpoint: endpoint,body: body);
    });
  }

}*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../app/modules/login/models/login_model.dart';
import '../app/modules/userPersonalData/models/user_personal_data_model.dart';
import '../app/routes/app_pages.dart';
import '../models/logged_in_user_model.dart';
import '../services/local_services.dart';
import '../services/notification_service.dart';
import '../services/remote_services.dart';
import '../common_widgets/custom_snackbar.dart';
import '../constraints/api_end_points.dart';

class SocialLoginController extends GetxController {
  final isLoading = false.obs;

  final loginModel = LoginModel().obs;
  final userDataModel = UserDataModel().obs;

  late final GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    super.onInit();

  }

  // ==================== Loading Dialog Helpers ====================
  void _showLoadingDialog() {
    isLoading.value = true;
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void _hideLoadingDialog() {
    isLoading.value = false;
    if (Get.isDialogOpen ?? false) Get.back();
  }

  void _showError(String msg) {
    _hideLoadingDialog();
    CustomSnackBar(msg: msg, isSuccess: false).showSnackBar();
  }

  // ==================== FACEBOOK LOGIN ====================
  Future<void> facebookLogin() async {
    _showLoadingDialog();
    try {
      final result = await FacebookAuth.i.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        _hideLoadingDialog();
        return;
      }

      final user = await FacebookAuth.i.getUserData();

      final body = {
        'facebook_id': user['id'] ?? "",
        'google_id': "",
        'apple_id': "",
        'name': user['name'] ?? "",
        'email': user['email'] ?? "",
        'phone': "",
      };

      await _processLogin(body);
    } catch (e) {
      if (kDebugMode) print(e);
      _showError("Facebook login failed");
    } finally {
      _hideLoadingDialog();
    }
  }

  // ==================== GOOGLE LOGIN ====================
  Future<void> googleLogin() async {
    _showLoadingDialog();

    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize(
      clientId:
          "979394384810-r3lshc9rcs2kgbqrd3sd82mbkegs6en3.apps.googleusercontent.com",
    );

    try {
      await _googleSignIn.signOut(); final account = await _googleSignIn.authenticate();
      if (account == null) {
        _hideLoadingDialog();
        return; // user canceled
      }

      final body = {
        'facebook_id': "",
        'google_id': account.id,
        'apple_id': "",
        'name': account.displayName ?? "",
        'email': account.email,
        'phone': "",
      };

      await _processLogin(body);
    } catch (e) {
      if (kDebugMode) print(e);
      _showError("Google login failed");
    } finally {
      _hideLoadingDialog();
    }
  }

  // ==================== APPLE LOGIN ====================
  Future<void> appleLogin() async {
    _showLoadingDialog();
    try {
      if (!await SignInWithApple.isAvailable()) {
        _showError("Apple Sign-In is not available on this device.");
        return;
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final body = {
        'facebook_id': "",
        'google_id': "",
        'apple_id': credential.userIdentifier ?? "",
        'name': credential.givenName ?? "",
        'email': credential.email ?? "",
        'phone': "",
      };

      await _processLogin(body);
    } catch (e) {
      if (kDebugMode) print("Apple login error: $e");
      _showError("Apple login failed");
    } finally {
      _hideLoadingDialog();
    }
  }

  // ==================== CORE LOGIN PROCESS ====================
  Future<void> _processLogin(Map<String, dynamic> body) async {
    try {
      final data = await RemoteServices.postRequest(
        endpoint: APIEndPoints.socialLoginEndpoint,
        body: body,
      );

      if (data == null) throw "Login failed";

      loginModel.value = LoginModel.fromJson(data);
      await LocalServices.storeToken(loginModel.value.apiToken ?? "");
      await LocalServices.storeLoggedInUser(
        loginModel.value.data ?? LoggedInUserModel(),
      );

      await fetchUserData();
      await _handleNext();
    } catch (e) {
      if (kDebugMode) print(e);
      _showError("Login process failed");
    }
  }

  // ==================== FETCH USER DATA ====================
  Future<void> fetchUserData() async {
    try {
      final res = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getUserData,
      );
      if (res != null) {
        userDataModel.value = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(
          userDataModel.value.data ?? UserData(),
        );
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  // ==================== NAVIGATION ====================
  Future<void> _handleNext() async {
    final is2FACompleted = await LocalServices.get2FaCompletedStatus();
    await LocalServices.clearReferralData();
    await _storeDeviceToken();

    final is2faRequired = userDataModel.value.data?.is2faStatusCheck == 1;
    final isPending =
        (loginModel.value.data?.subscriptionStatus ?? "").toLowerCase() ==
        "pending";

    if (is2faRequired && !is2FACompleted) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
    } else if (isPending) {
      Get.offAllNamed(Routes.SUBSCRIPRTION);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // ==================== DEVICE TOKEN ====================
  Future<void> _storeDeviceToken() async {
    final token = await NotificationServices.instance.getDeviceToken();
    if (token != null) {
      await RemoteServices.postRequest(
        endpoint: APIEndPoints.storeDeviceToken,
        body: {"device_token": token},
      );
    }
  }
}
