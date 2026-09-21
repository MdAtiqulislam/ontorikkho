import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/announcements/controllers/announcements_controller.dart';
import 'package:ontorikkho/app/modules/announcements/views/announcementShimmer.dart';
import 'package:ontorikkho/app/modules/home/views/announcement_card.dart';
import '../../../../common_widgets/empty_screen.dart';

class UrgentTabView extends GetView<AnnouncementsController> {
  const UrgentTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => CustomScrollView(
        controller: controller.urgentAnnouncementScrollController,
        slivers: [
          // Loader while initial data loading
          if (controller.isLoadingUrgentData.value)
            const AnnouncementShimmerList(),

          // Show announcements if available
          if (!controller.isLoadingUrgentData.value &&
              controller.urgentAnnouncements.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final announcement = controller.urgentAnnouncements[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: AnnouncementCard(
                            title: announcement.title ?? "",
                            desc: announcement.description ?? "",
                            duration: announcement.time ?? "",
                          ),
                        ),
                        // Show divider except for the last item
                        if (index < controller.urgentAnnouncements.length - 1)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Divider(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: controller.urgentAnnouncements.length,
                ),
              ),
            ),

          // Show empty state if no announcement found
          if (!controller.isLoadingUrgentData.value &&
              controller.urgentAnnouncements.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: EmptyScreen(message: "No urgent announcement found."),
              ),
            ),

          // Loader for pagination / load more
          SliverToBoxAdapter(
            child: controller.isLoadingMoreUrgentData.value
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
