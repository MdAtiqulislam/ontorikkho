import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/common_widgets/app_list_tile_button.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../constraints/app_colors.dart';
import '../controllers/payment_options_controller.dart';

class PaymentOptionsView extends GetView<PaymentOptionsController> {
  const PaymentOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Payment Options"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
          ),
          child: Column(
            children: [
              SizedBox(height: AppDimensions.widgetPadding.h),
              AppListTileButton(
                backgroundColor: Colors.white,
                margin: EdgeInsets.zero,
                elevation: 1,
                onTap: () {},
                text: "Bank Account",
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.headerText,
                  size: 16.sp,
                ),
              ),
              SizedBox(height: AppDimensions.contentPadding.h,),
              AppListTileButton(
                margin: EdgeInsets.zero,
                backgroundColor: Colors.white,
                elevation: 1,
                onTap: () {},
                text: "Card",
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.headerText,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
