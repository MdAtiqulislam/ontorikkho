/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/store/views/custom_tabs.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_list_tile.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

import '../../../../common_widgets/sticky_header.dart';
import '../../../../constraints/app_colors.dart';
import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Store"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
            ),
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyHeaderDelegate(
                    height: 60.h + AppDimensions.widgetPadding.h,
                    // Adjust this height based on TabSection
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.widgetPadding.h),
                        TabSection(
                          tab_1: "Order Tracks",
                          tab_2: "Order History",
                          selectedTab: controller.selectedTab.value,
                          onTabChange: (index) {
                            controller.selectedTab.value = index;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyHeaderDelegate(
                    height: 30.sp,
                    // Adjust based on your SectionHeader height
                    child: SectionHeader(
                      title: "Products",
                      showMoreButton: false,
                    ),
                  ),
                ),

                if (controller.selectedTab.value == 0)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: 10, (
                      buildContext,
                      index,
                    ) {
                      return CustomListTile(
                        onTap: (){
                          Get.toNamed(Routes.PRODUCT_DETAILS);
                        },
                        leading: HeaderText(text: "${index + 1}", size: 12),
                        title: "Child Education",
                        localAvatar: 'assets/images/moc_image_4.png',
                        subTitle: BodyText(
                          text: "Lorem ipsum dolor sit...",
                          maxLine: 1,
                          size: 11,
                        ),
                        trailing: AppButton(
                          text: "Add to cart",
                          onTap: () {},
                          bgColor: AppColors.primaryColor,
                          verticalPadding: 5,
                          fontSize: 10,
                        ),
                      );
                    }),
                  ),
                if (controller.selectedTab.value == 1)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: 10, (
                      buildContext,
                      index,
                    ) {
                      return CustomListTile(
                        onTap: (){
                          Get.toNamed(Routes.PRODUCT_DETAILS);
                        },
                        leading: HeaderText(text: "${index + 1}", size: 12),
                        title: "Child Education",
                        localAvatar: 'assets/images/moc_image_2.png',
                        subTitle: BodyText(
                          text: "Lorem ipsum dolor sit...",
                          maxLine: 1,
                          size: 11,
                        ),
                        trailing: AppButton(
                          text: "Add to cart",
                          onTap: () {
                          },
                          bgColor: AppColors.primaryColor,
                          verticalPadding: 5,
                          fontSize: 10,
                        ),
                      );
                    }),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.widgetPadding.h),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ontorikkho/app/modules/cart/controllers/cart_controller.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/store_controller.dart';
import 'products_view.dart';

class StoreView extends GetView<StoreController> {
   const StoreView({super.key});



  @override
  Widget build(BuildContext context) {
    CartController cartController=Get.put(CartController());
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Store"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body:Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
            ),
            child:ProductsView()
        ),
        bottomSheet: Obx(() => cartController.cartItems.isNotEmpty
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
