import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/pendingList/views/pending_list_shimmer.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_list_tile.dart';
import '../../../../constraints/app_colors.dart';
import '../controllers/pending_list_controller.dart';

class PendingListView extends GetView<PendingListController> {
  const PendingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "New Members"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
          ),
          child: Obx(
            () =>
                controller.isLoading.value
                    ? PendingListShimmer()
                    : Stack(
                      children: [
                        CustomScrollView(
                          controller: controller.loadMoreScrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: controller.pendingList.length,
                                (buildContext, index) {
                                  var data = controller.pendingList[index];

                                  return CustomListTile(
                                    title: data.name ?? "",
                                    avatar: data.profileImage ?? "",
                                    trailing: AppButton(
                                      text: "Approve",
                                      onTap: () {
                                        controller.pendingUserApproval(id: data.id.toString());
                                      },
                                      verticalPadding: 5.h,
                                      bgColor: AppColors.primaryColor,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (controller.isLoadingMore.value) ...[
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: AppDimensions.widgetPadding.h,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Center(child: CircularProgressIndicator()),
                              ),
                            ],
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                            ),
                          ],
                        ),
                        if(controller.isUpdating.value)LoadingScreen()
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
