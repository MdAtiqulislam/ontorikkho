import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/events/views/event_grid_item.dart';
import 'package:ontorikkho/app/modules/favourite/views/favourite_events_tab_view.dart';
import 'package:ontorikkho/app/modules/favourite/views/favourite_products_tab_view.dart';
import 'package:ontorikkho/common_widgets/app_list_tile_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_list_tile.dart';
import '../../../../common_widgets/sticky_header.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../../../../common_widgets/custom_tabs.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/favourite_controller.dart';

class FavouriteView extends GetView<FavouriteController> {
  const FavouriteView({super.key});
  @override
  Widget build(BuildContext context) {
    CartController cartController=Get.put(CartController());
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Favourites", showBackButton: true),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
              () => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
            ),
            child: Column(
              children: [
                SizedBox(height: AppDimensions.widgetPadding.h),
                CustomTabs(
                  tab_1: "Events",
                  tab_2: "Products",
                  selectedTab: controller.selectedTab.value,
                  onTabChange: (index) {
                    controller.selectedTab.value = index;
                  },
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Obx(() => IndexedStack(
                    index: controller.selectedTab.value,
                    children:  [
                      FavouriteEventsTabView(),
                      FavouriteProductsTabView(),

                    ],
                  ),),
                )
              ],
            ),
          ),
        ),
        bottomSheet: Obx(() => cartController.cartItems.isNotEmpty && controller.selectedTab.value==1
            ? Container(
          padding:  EdgeInsets.all(AppDimensions.widgetPadding.r),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ৳${cartController.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppButton(
                height: 40.sp,
                onTap: () {
                  Get.toNamed(Routes.CART);
                },
                text: "View Cart",
                bgColor: AppColors.primaryColor,
                showBorder: false,
              ),
            ],
          ),
        )

            : const SizedBox.shrink()),
      ),
    );
  }

}
