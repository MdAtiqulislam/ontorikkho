import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_info_dialouge.dart';
import '../../../../common_widgets/app_list_tile_button.dart';
import '../../../../common_widgets/custom_card.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../controllers/settings_and_support_controller.dart';


class SettingsAndSupportView extends GetView<SettingsAndSupportController> {
  const SettingsAndSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          title: "Settings & Supports",
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.widgetPadding.h),
                        Expanded(
                          child: CustomCard(
                            width: Get.width,
                            horizontalPadding: AppDimensions.horizontalPadding.w,
                            verticalPadding: AppDimensions.verticalPadding.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBodySection(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimensions.widgetPadding.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildBodySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AppListTileButton(
          margin: EdgeInsets.zero,
          onTap: () => Get.toNamed(Routes.PRIVACY),
          text: "Privacy",
          textColor: AppColors.headerText,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppDimensions.contentPadding.h),
          trailing: Icon(Icons.arrow_forward_ios_sharp, color: AppColors.headerText, size: 16.sp),
        ),

       /* AppListTileButton(
          margin: EdgeInsets.zero,
          onTap: () => Get.toNamed(Routes.PUSH_NOTIFICATION),
          text: "Push Notifications",
          textColor: AppColors.headerText,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppDimensions.contentPadding.h),
          trailing: Icon(Icons.arrow_forward_ios_sharp, color: AppColors.headerText, size: 16.sp),
        ),
*/
        AppListTileButton(
          margin: EdgeInsets.zero,
          onTap: () => Get.toNamed(Routes.SUPPORT),
          text: "Support",
          textColor: AppColors.headerText,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppDimensions.contentPadding.h),
          trailing: Icon(Icons.arrow_forward_ios_sharp, color: AppColors.headerText, size: 16.sp),
        ),

        AppListTileButton(
          margin: EdgeInsets.zero,
          onTap: () => Get.toNamed(Routes.FAQ),
          text: "FAQs",
          textColor: AppColors.headerText,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppDimensions.contentPadding.h),
          trailing: Icon(Icons.arrow_forward_ios_sharp, color: AppColors.headerText, size: 16.sp),
        ),

        const Divider(),

        AppListTileButton(
          margin: EdgeInsets.zero,
          text: "Two Factor Authentication",
          textColor: AppColors.headerText,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppDimensions.contentPadding.h),
          trailing: Obx(() => Switch(
            value: controller.isTwoFaEnabled.value,
            onChanged: (val) async {
              if (!val) {

                final confirm = await Get.dialog<bool>(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r), // Rounded corners
                    ),
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon + Title Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "Turn Off 2FA?",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Are you sure you want to disable 2FA?",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(result: false),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey.shade400),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black87, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppDimensions.contentPadding.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Get.back(result: true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
                                  ),
                                  child: Text(
                                    "Disable",
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                );

                if (confirm ?? false) {
                  controller.toggleTwoFA(val); // OFF confirmed
                }
              } else {
                // OFF → ON, সরাসরি ON করা
                controller.toggleTwoFA(val);
              }
            },
            activeColor: AppColors.primaryColor,
          )),
          onTap: () {},
        ),
      ],
    );
  }


}
