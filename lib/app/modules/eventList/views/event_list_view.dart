import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../common_widgets/event_list_item.dart';
import '../controllers/event_list_controller.dart';

class EventListView extends GetView<EventListController> {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(
        () => Scaffold(
          appBar: CustomAppBar(
            title: controller.type.value,
            showBackButton: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: controller.eventList.length,
                    (buildContext, index) {
                      return EventListItem(
                        event: controller.eventList[index],
                        showJoinButton: true,
                      );
                    },
                  ),
                ),

                if (controller.isLoadingMore.value)
                  SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
