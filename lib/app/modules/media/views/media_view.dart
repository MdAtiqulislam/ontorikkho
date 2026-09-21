import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/media/views/photo_gallery.dart';
import 'package:ontorikkho/app/modules/media/views/video_gallery.dart';

import '../../../../common_widgets/custom_list_tile.dart';
import '../../../../common_widgets/section_header.dart';
import '../../../../common_widgets/sticky_header.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../../../../common_widgets/custom_tabs.dart';
import '../controllers/media_controller.dart';

class MediaView extends GetView<MediaController> {
  const MediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Gallery & Media", showBackButton: true),
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
                  tab_1: "Photos",
                  tab_2: "Videos",
                  selectedTab: controller.selectedTab.value,
                  onTabChange: (index) {
                    controller.selectedTab.value = index;
                  },
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.selectedTab.value,
                      children: [
                        PhotoGallery(),
                        VideoGallery(),
                        //OrderHistoryTabView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
