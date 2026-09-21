import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/pages/controllers/pages_controller.dart';
import 'package:ontorikkho/app/modules/pages/views/page_list_shimmer_view.dart';
import 'package:ontorikkho/app/modules/pages/widgets/page_list_item.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/custom_search_bar.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../routes/app_pages.dart';
import '../../pageFeed/controllers/page_feed_controller.dart';

class PagesListView extends GetView<PagesController> {
  final String title;

  const PagesListView({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: title, showBackButton: true),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const PagesListShimmerView();
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.widgetPadding.h),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding.w,
                      ),
                      child: CustomSearchBar(
                        title: title,
                        icon: Icon(Icons.search),
                        onTap: controller.goToSearchPage,
                      ),
                    ),
                    // Implement search functionality here),
                  ),
                  SliverToBoxAdapter(child: Divider()),
                  controller.pagesList.isNotEmpty
                      ? SliverList.builder(
                        itemCount: controller.pagesList.length,
                        itemBuilder: (buildContext, index) {
                          final pageItem = controller.pagesList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.horizontalPadding.w,
                              vertical: AppDimensions.verticalPadding * .5.h,
                            ),
                            child: PageListItem(
                              pageItem: pageItem,
                              onActionTap: (action, pageId) {
                               controller.handelPageAction(
                                 action: action,
                                 pageId: pageId
                               );
                              },
                              onDetails: () {
                                Get.put(
                                  PageFeedController(),
                                ).getPageDetails(id:pageItem.page?.id??0);
                                Get.toNamed(Routes.PAGE_FEED);
                              },
                            ),
                          );
                        },
                      )
                      : SliverToBoxAdapter(
                        child: EmptyScreen(
                          animationPath: "assets/animations/nodata.json",
                          message:
                              "Right now there are no pages available. Try refreshing or check back later.",
                        ),
                      ),
                ],
              ),
              if(controller.isUpdating.value)LoadingScreen()
            ],
          );
        }),
      ),
    );
  }
}
