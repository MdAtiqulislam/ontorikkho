
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/favourite/controllers/favourite_controller.dart';
import 'package:ontorikkho/app/modules/orderHistory/controllers/order_history_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/app_list_tile_button.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:ontorikkho/services/local_services.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/own_profile_controller.dart';

class OwnProfileView extends GetView<OwnProfileController> {
  const OwnProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:  CustomAppBar(showBackButton: true),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(
              () => controller.isLoading.value
              ? const LoadingScreen()
              : SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
            ),
            child: Column(
              children: [
                SizedBox(height: AppDimensions.widgetPadding.h),
                CustomCard(
                  width: Get.width,
                  horizontalPadding: AppDimensions.horizontalPadding.w,
                  verticalPadding: AppDimensions.verticalPadding.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      SizedBox(height: AppDimensions.sectionPadding.h),
                      _buildBodySection(),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.widgetPadding.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final user = controller.user.value;
    return Column(
      children: [
        CustomCircleAvatar(
          width: 100,
          height: 100,
          image: user.profileImage ?? "",
        ),
        SizedBox(height: AppDimensions.widgetPadding.h),
        HeaderText(text: user.name ?? ""),
        BodyText(text: user.email ?? ""),
        SizedBox(height: AppDimensions.widgetPadding.h),
        AppButton(
          text: "Edit Profile",
          onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
          bgColor: AppColors.primaryColor.withAlpha(30),
          textColor: AppColors.primaryColor,
          showBorder: false,
        ),
      ],
    );
  }

  Widget _buildBodySection() {
    final user = controller.user.value;
    final isApproved = user.subscriptionStatus == "Approved";
    final cartController = Get.put(CartController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Personal Info"),
        _menuTile(
          icon: Icons.account_circle_outlined,
          text: "Personal Data",
          onTap: () => Get.toNamed(Routes.USER_PERSONAL_DATA),
        ),
        _menuTile(
          icon: Icons.feed_outlined,
          text: "Member Hub",
          onTap: () => Get.toNamed(Routes.FOR_YOU),
        ),

        if (isApproved)
          _menuTile(
            icon: Icons.card_membership_rounded,
            text: "Membership Renewal",
            onTap: () => Get.toNamed(Routes.MEMBERSHIP_RENEW),
          ),

        SizedBox(height: AppDimensions.contentPadding.h),
        if (isApproved)_sectionHeader("General"),

        if (isApproved)
          _menuTile(
            icon: Icons.account_box,
            text: "Directory",
            onTap: () => Get.toNamed(Routes.DIRECTORY),
          ),
        if (isApproved)
          _menuTile(
            icon: Icons.storefront_outlined,
            text: "Club Store",
            onTap: () => Get.toNamed(Routes.STORE),
          ),

        // 🧾 My Orders Segment
        if (isApproved) ...[
          SizedBox(height: AppDimensions.contentPadding.h),
          _sectionHeader("My Orders"),
          Obx(
                () => _menuTile(
              icon: Icons.shopping_cart_outlined,
              text: "My Cart",
              badgeCount: cartController.cartItemCount,
              onTap: () => Get.toNamed(Routes.CART),
            ),
          ),
          _menuTile(
            icon: Icons.receipt_long_outlined,
            text: "Order History",
            onTap: () {
              Get.put(OrderHistoryController()).fetchOrderHistory();
              Get.toNamed(Routes.ORDER_HISTORY);
            },
          ),
          /*_menuTile(
            icon: Icons.local_shipping_outlined,
            text: "Order Track",
            onTap: () => Get.toNamed(Routes.ORDER_TRACK),
          ),*/
        ],

        SizedBox(height: AppDimensions.contentPadding.h),
        _sectionHeader("Other"),

        if (isApproved)
          _menuTile(
            icon: Icons.favorite_border,
            text: "Favourites",
            onTap: () {
              Get.put(FavouriteController()).getData();
              Get.toNamed(Routes.FEVOURITE);
            },
          ),
        _menuTile(
          icon: Icons.settings_outlined,
          text: "Settings & Support",
          onTap: () => Get.toNamed(Routes.SETTINGS_AND_SUPPORT),
        ),
        if (isApproved)_menuTile(
          icon: Icons.share_outlined,
          text: "Invite Friends",
          onTap: () => Get.toNamed(Routes.INVITE_FRIENDS),
        ),


        SizedBox(height: AppDimensions.widgetPadding.h),
        AppButton(
          text: "Logout",
          onTap: () {
            LocalServices.deleteAllData();
            Get.offAllNamed(Routes.LOGIN);
          },
          borderColor: Colors.red,
          textColor: Colors.red,
          leading: const Icon(Icons.logout_rounded, color: Colors.red),
        ),

        if (Platform.isIOS) ...[
          SizedBox(height: AppDimensions.widgetPadding.h),
          AppButton(
            text: "Delete Account",
            onTap: () {
              Get.defaultDialog(
                title: "Warning!",
                middleText: "All your data will be lost. Are you sure?",
                titleStyle: const TextStyle(color: Colors.red),
                textConfirm: "Yes, Delete",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                cancelTextColor: Colors.black,
                buttonColor: Colors.red,
                onConfirm: () {
                  LocalServices.deleteAllData();
                  Get.offAllNamed(Routes.LOGIN);
                },
              );
            },
            borderColor: Colors.red,
            textColor: Colors.red,
            leading: const Icon(Icons.delete_forever, color: Colors.red),
          ),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: BodyText(text: title, align: TextAlign.start),
  );

  Widget _menuTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return AppListTileButton(
      margin: EdgeInsets.zero,
      onTap: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: AppColors.headerText),
          if (badgeCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      text: text,
      textColor: AppColors.headerText,
      padding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: AppDimensions.contentPadding.h,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColors.headerText,
        size: 16.sp,
      ),
    );
  }
}
