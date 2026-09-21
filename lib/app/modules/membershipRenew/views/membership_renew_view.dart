import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

import '../controllers/membership_renew_controller.dart';

class MembershipRenewView extends GetView<MembershipRenewController> {
  const MembershipRenewView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Membership Renewal"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
          ),
          child: Obx(()=>Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: AppDimensions.widgetPadding.h),
                  CustomCard(
                    horizontalPadding: AppDimensions.horizontalPadding.w,
                    verticalPadding: AppDimensions.verticalPadding.h,

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyText(text: "Member Name"),
                                HeaderText(
                                  text: controller.user.value.name??"",
                                  align: TextAlign.start,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                BodyText(text: "Membership Type"),
                                HeaderText(text: controller.user.value.membershipType??""),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.contentPadding.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyText(text: "Validity date"),
                                HeaderText(text: controller.user.value.expiredDate??""),
                              ],
                            ),
                           /* Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                BodyText(text: "Auto Renewal"),
                                Obx(
                                      () => Switch(
                                    activeColor: Colors.white,
                                    activeTrackColor: AppColors.primaryColor,
                                    value: controller.autoRenewal.value,
                                    onChanged: (value) {
                                      controller.autoRenewal.value = value;
                                    },
                                  ),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.widgetPadding.h),
                  AppButton(
                    text: "Upgrade Membership Plan",
                    onTap: () {
                      Get.toNamed(Routes.MEMBERSHIP_PLANS);
                    },
                    bgColor: AppColors.primaryColor,
                    trailing: Icon(Icons.upgrade,color: Colors.white,),

                  ),
                ],
              ),
              if(controller.isLoadin.value)LoadingScreen()
            ],
          ),)
        ),
      ),
    );
  }
}
