/*
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'app_config_model.dart';
import 'app_update_service.dart';

class AppUpdateController extends GetxController {
  RxBool loading = false.obs;
  AppConfigModel? config;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkForUpdate() async {
    loading.value = true;

    config = await AppUpdateService.getConfig();
    if (config == null) {
      loading.value = false;
      return;
    }

    PackageInfo info = await PackageInfo.fromPlatform();
    String current = info.version;

    bool needUpdate = false;

    if (Platform.isAndroid) {
      if (current != config!.androidVersion &&
          current != config!.androidTestVersion) {
        needUpdate = true;
      }
    }

    if (Platform.isIOS) {
      if (current != config!.iosVersion && current != config!.iosTestVersion) {
        needUpdate = true;
      }
    }

    loading.value = false;

    if (needUpdate) {
      // Delay to ensure overlay context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showUpdateDialog();
      });
    }
  }

  void showUpdateDialog() {
    final String? url =
        Platform.isAndroid
            ? config?.majorMsg.url!["apk"]
            : config?.majorMsg.url?["ios"];

    final context = Get.overlayContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => WillPopScope(
            onWillPop: () async => false, // disable back button
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadius.r,
                ),
              ),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h,
                ),
                //constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    HeaderText(text: config!.majorMsg.title),
                    SizedBox(height: 15.h),

                    // Message
                    BodyText(
                      text:config!.majorMsg.msg,
                    ),
                     SizedBox(height: AppDimensions.sectionPadding.h),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                            text: "Cancel",
                           // bgColor: AppColors.primaryColor,
                            showBorder: false,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            textColor: Colors.grey[700],
                            splashColor: AppColors.dangerColor,
                            onTap: (){
                              exit(0); // Force exit
                            }),
                         SizedBox(width: AppDimensions.contentPadding.w),
                        AppButton(
                            text: config!.majorMsg.button,
                            bgColor: AppColors.primaryColor,
                            showBorder: false,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            splashColor: Color(0xFF0A3524),
                            onTap: (){
                          if (url != null && url.isNotEmpty) {
                            launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        })

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
*/



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_config_model.dart';
import 'app_update_service.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class AppUpdateController extends GetxController {
  RxBool loading = false.obs;
  AppConfigModel? config;
  OverlayEntry? _overlayEntry;

  Future<void> checkForUpdate() async {
    loading.value = true;

    config = await AppUpdateService.getConfig();
    if (config == null) {
      loading.value = false;
      return;
    }

    PackageInfo info = await PackageInfo.fromPlatform();
    String current = info.version;

    bool needUpdate = false;

    if (Platform.isAndroid) {
      if (current != config!.androidVersion &&
          current != config!.androidTestVersion) {
        needUpdate = true;
      }
    }

    if (Platform.isIOS) {
      if (current != config!.iosVersion &&
          current != config!.iosTestVersion) {
        needUpdate = true;
      }
    }

    loading.value = false;

    if (needUpdate) {
      // Delay to ensure overlay context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPersistentOverlay();
      });
    }
  }

  void _showPersistentOverlay() {
    final String? url = Platform.isAndroid
        ? config!.majorMsg.url!["apk"]
        : config?.majorMsg.url?["ios"];

    if (_overlayEntry != null) return; // Already shown

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black38,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderText(text: config!.majorMsg.title),
                SizedBox(height: 15.h),
                BodyText(text: config!.majorMsg.msg,maxLine: 20,),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Cancel",
                      showBorder: false,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      textColor: Colors.grey[700],
                      splashColor: AppColors.dangerColor,
                      onTap: () => exit(0),
                    ),
                    SizedBox(width: 12.w),
                    AppButton(
                      text: config!.majorMsg.button,
                      bgColor: AppColors.primaryColor,
                      showBorder: false,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      splashColor: Color(0xFF0A3524),
                      onTap: () {
                        if (url != null && url.isNotEmpty) {
                          launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(Get.overlayContext!)?.insert(_overlayEntry!);
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
