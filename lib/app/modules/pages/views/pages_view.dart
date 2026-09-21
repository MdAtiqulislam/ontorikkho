import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';

import '../../../../common_widgets/custom_filter_chip.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_search_bar.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../services/my_pages_service.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../../pageFeed/controllers/page_feed_controller.dart';
import '../controllers/pages_controller.dart';

class PagesView extends GetView<PagesController> {
  const PagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Pages"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.initData,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppDimensions.widgetPadding.h),
                      ),
                      _buildTopBar(),
                      _buildManagedPagesSection(),
                      if (controller.isLoadingMore.value)
                        const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),

              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }

  SliverToBoxAdapter _buildTopBar() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          CustomSearchBar(
              title: "Pages",
              icon: Icon(Icons.search),
              onTap: controller.goToSearchPage,
          ),
          SizedBox(height: 10.h),
          _buildFilterChips(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
        PageFilterType.values.map((type) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CustomFilterChip(
                label: type.label,
                onTap: ()=> controller.changeView(type: type),
            ),
          );
        }).toList(),
      ),
    );
  }

  SliverToBoxAdapter _buildManagedPagesSection() {

    final myPageService = Get.find<MyPageService>();

    return SliverToBoxAdapter(
      child: Obx(() {
        if (myPageService.myPages.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: 40.h,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.manage_accounts_outlined,
                  size: 60.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  "You don't manage any pages yet",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Create a new page or wait until you're assigned as an admin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
              ),
              child: Text(
                "Pages you manage",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: AppDimensions.widgetPadding.h),

            ListView.builder(
              itemCount: myPageService.myPages.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final page = myPageService.myPages[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                    vertical: 6.h,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      leading: CircleAvatar(
                        radius: 22.r,
                        backgroundImage: NetworkImage(
                          page.page?.profileImage ?? "",
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      title: Text(
                        page.page?.name ?? "Unnamed Page",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "${page.followerCount ?? 0} followers",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Get.put(PageFeedController())
                            .getPageDetails(id: page.page?.id ?? 0);
                        Get.toNamed(Routes.PAGE_FEED);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
