import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/pages/controllers/search_page_controller.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../routes/app_pages.dart';
import '../../friends/controllers/friends_controller.dart';
import '../../friends/models/friend_basic_info_model.dart';
import '../../friends/models/search_friend_model.dart';
import '../../friends/widgets/friend_search_item.dart';
import '../../pageFeed/controllers/page_feed_controller.dart';
import '../widgets/page_list_item.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Search Pages",
          showBackButton: true,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(()=>Stack(
          children: [
            Column(
              children: [
                /// 🔍 Search Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                    ),
                    child: TextField(
                      onChanged: controller.onQueryChanged,
                      decoration: InputDecoration(
                        hintText: "Search page...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),

                /// 📋 Result Section
                Expanded(
                  child: Obx(() {
                    /// ⏳ Initial Loading
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    /// ❌ Empty State
                    if (controller.isEmpty.value) {
                      return Center(child: Text("No friends found 😔"));
                    }

                    /// 📋 List
                    return RefreshIndicator(
                      onRefresh: controller.refreshSearch,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount:
                        controller.pagesList.length +
                            (controller.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          /// 📄 Loader (bottom)
                          if (index >= controller.pagesList.length) {
                            return Padding(
                              padding: EdgeInsets.all(12.h),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final  page = controller.pagesList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.horizontalPadding.w,
                              vertical: AppDimensions.verticalPadding * .5.h,
                            ),
                            child: PageListItem(
                              pageItem: page,
                              onActionTap: (action, pageId) {
                                controller.handelPageAction(
                                    action: action,
                                    pageId: pageId
                                );
                              },
                              onDetails: () {
                                Get.put(
                                  PageFeedController(),
                                ).getPageDetails(id:page.page?.id??0);
                                Get.toNamed(Routes.PAGE_FEED);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
            if(controller.isUpdating.value)LoadingScreen()
          ],
        )),
      ),
    );
  }
}
