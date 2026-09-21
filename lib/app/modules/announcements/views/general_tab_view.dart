import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/announcements/controllers/announcements_controller.dart';
import 'package:ontorikkho/app/modules/announcements/views/announcementShimmer.dart';
import 'package:ontorikkho/app/modules/home/views/announcement_card.dart';
import '../../../../common_widgets/empty_screen.dart';

class GeneralTabView extends GetView<AnnouncementsController> {
  const GeneralTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => CustomScrollView(
        controller: controller.generalAnnouncementScrollController,
        slivers: [
          if (controller.isLoadingGeneralData.value)
            const AnnouncementShimmerList(),

          if (!controller.isLoadingGeneralData.value &&
              controller.generalAnnouncements.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final announcement = controller.generalAnnouncements[index];
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
                        // Divider only if NOT last item
                        if (index < controller.generalAnnouncements.length - 1)
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
                  childCount: controller.generalAnnouncements.length,
                ),
              ),
            ),

          if (!controller.isLoadingGeneralData.value &&
              controller.generalAnnouncements.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: EmptyScreen(message: "No announcement found."),
              ),
            ),

          SliverToBoxAdapter(
            child: controller.isLoadingMoreGeneralData.value
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
