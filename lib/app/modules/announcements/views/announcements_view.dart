import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/announcements/views/general_tab_view.dart';
import 'package:ontorikkho/app/modules/announcements/views/urgent_tab_view.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../common_widgets/custom_tabs.dart';
import '../../home/views/announcement_card.dart';
import '../controllers/announcements_controller.dart';

class AnnouncementsView extends GetView<AnnouncementsController> {
  const AnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Announcements & News", showBackButton: true),
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
                  tab_1: "General Updates",
                  tab_2: "Urgent Notice",
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
                      GeneralTabView(),
                      UrgentTabView(),
                    ],
                  ),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
