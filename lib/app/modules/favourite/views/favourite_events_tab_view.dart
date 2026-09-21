import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/events/views/event_grid_item.dart';
import 'package:ontorikkho/app/modules/favourite/controllers/favourite_controller.dart';

import '../../../../common_widgets/custom_info_dialouge.dart';
import '../../../../common_widgets/empty_screen.dart';
import '../../announcements/views/announcementShimmer.dart';

class FavouriteEventsTabView extends GetView<FavouriteController> {
  const FavouriteEventsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          if (controller.isLoading.value) const AnnouncementShimmerList(),

          if (!controller.isLoading.value && controller.events.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final event = controller.events[index];
                  return RepaintBoundary(
                    child: Obx(() {
                      final isFav = controller.events.any(
                        (e) => e.id == event.id,
                      );
                      return EventGridItem(
                        eventName: event.title ?? "",
                        date: event.startDate ?? "",
                        duration: event.timeDifference ?? "",
                        isFavourite: isFav.obs,
                        image: event.image,
                        onTapDetails: () {
                          controller.getDetails(event: event);
                        },
                        showRemoveButton: true,
                        onTapRemove: () {
                          Get.dialog(
                            CustomInfoDialog(
                              title: "Attention",
                              description:
                                  "This item will remove from favourite list. Do you want to continue?",
                              onAccept: () {
                                controller.addOrUpdateFavouriteEvent(
                                  event: event,
                                );
                              },
                              acceptText: "Yes",
                              declineText: "No",
                            ),
                          );
                        },
                      );
                    }),
                  );
                }, childCount: controller.events.length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: .75,
                ),
              ),
            ),

          if (!controller.isLoading.value && controller.events.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: EmptyScreen(
                  message: "You don't have any favourite events.",
                  animationPath: "assets/animations/nodata.json",
                ),
              ),
            ),
        ],
      ),
    );
  }
}
