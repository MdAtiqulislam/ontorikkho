import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/orderHistory/views/order_history_shimmer.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../common_widgets/empty_screen.dart';
import '../../../../common_widgets/section_header.dart';
import '../../../../common_widgets/sticky_header.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../../orderDetails/controllers/order_details_controller.dart';
import '../controllers/order_history_controller.dart';
import 'order_history_card.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Order History"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: CustomScrollView(
              controller: controller.historyScrollController,
              slivers: [
                // Sticky Header
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyHeaderDelegate(
                    height: 30.sp,
                    child: SectionHeader(
                      title: "Order History",
                      showMoreButton: false,
                    ),
                  ),
                ),
                if (controller.isLoadingHistory.value) OrderHistoryShimmer(),

                if (!controller.isLoadingHistory.value) ...[
                  SliverPadding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final history = controller.orderHistory[index];
                        return RepaintBoundary(
                          child: OrderHistoryCard(
                            order: history,
                            onTap: () {
                              Get.put(
                                OrderDetailsController(),
                              ).getOrderDetails(orderId: history.id.toString());
                              Get.toNamed(Routes.ORDER_DETAILS);
                            },
                          ),
                        );
                      }, childCount: controller.orderHistory.length),
                    ),
                  ),

                  if (controller.orderHistory.isEmpty)
                    SliverToBoxAdapter(
                      child: EmptyScreen(
                        animationPath: "assets/animations/nodata.json",
                        message:
                            "You did not place any order yet! Please place an order first",
                      ),
                    ),
                  // Load more loader
                  SliverToBoxAdapter(
                    child:
                        controller.isLoadingMoreHistory.value
                            ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
