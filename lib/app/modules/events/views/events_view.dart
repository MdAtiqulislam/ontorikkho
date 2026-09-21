/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/events/views/event_grid_item.dart';
import 'package:ontorikkho/app/modules/events/views/event_shimmer.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_list_tile.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../common_widgets/empty_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () => controller.isLoading.value ? EventShimmerView() : _buildBody(),
        ),
      ),
    );
  }

  _buildBody() {
    final bool isEmpty =
        controller.ongoingEvents.isEmpty &&
        controller.upcomingEvents.isEmpty &&
        controller.expiredEvents.isNotEmpty;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
          ),
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.widgetPadding.h),
              ),

              // Upcoming Events Section
              if (controller.upcomingEvents.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: "Upcoming Events",
                    showMoreButton: false,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final event = controller.upcomingEvents[index];
                    return RepaintBoundary(
                      child: CustomListTile(
                        title: event.title ?? "",
                        avatar: event.image ?? "",
                        avatarHeight: 30.sp,
                        avatarWidth: 30.sp,
                        trailing: AppButton(
                          text: "Join Event",
                          onTap: () {
                            controller.joinEvent(event);
                          },
                          verticalPadding: 5.h,
                          bgColor: AppColors.primaryColor,
                          textTransform: TextTransform.none,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }, childCount: controller.upcomingEvents.length),
                ),
              ],

              // Events Grid Section
              if (controller.expiredEvents.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppDimensions.widgetPadding.h),
                      SectionHeader(title: "Events", showMoreButton: false),
                      SizedBox(height: AppDimensions.widgetPadding.h),
                    ],
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final event = controller.expiredEvents[index];
                    return RepaintBoundary(
                      child: Obx(() {
                        final isFav = controller.favouriteEvents.any(
                          (e) => e.id == event.id,
                        );
                        return EventGridItem(
                          eventName: event.title ?? "",
                          date: event.startDate ?? "",
                          duration: event.timeDifference ?? "",
                          image: event.image,
                          onTapDetails: () {
                            controller.getDetails(event: event);
                          },
                          onTapFavourite: () {
                            controller.addOrUpdateFavouriteEvent(event: event);
                          },
                          isFavourite: isFav.obs,
                        );
                      }),
                    );
                  }, childCount: controller.expiredEvents.length),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .7,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.sectionPadding.h),
                ),
              ],

              // Empty State
              if (isEmpty)
                SliverToBoxAdapter(
                  child: EmptyScreen(
                    message: 'No events available right now.',
                    icon: Icons.event_busy,
                  ),
                ),
              if (controller.isLoadingMore.value)
                SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
        if (controller.isUpdating.value) LoadingScreen(),
      ],
    );
  }
}


*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/eventList/controllers/event_list_controller.dart';
import 'package:ontorikkho/app/modules/events/views/event_grid_item.dart';
import 'package:ontorikkho/app/modules/events/views/event_shimmer.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/event_list_item.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../common_widgets/empty_screen.dart';
import '../../../routes/app_pages.dart';
import '../controllers/events_controller.dart';
import '../models/event_list_model.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
              () => controller.isLoading.value ? EventShimmerView() : _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final bool isEmpty = controller.upcomingEvents.isEmpty &&
        controller.ongoingEvents.isEmpty &&
        controller.expiredEvents.isEmpty;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
          ),
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.widgetPadding.h),
              ),

              // Upcoming Events Section
              if (controller.upcomingEvents.isNotEmpty)
                _buildEventListSection(
                  title: "Upcoming Events",
                  events: controller.upcomingEvents,
                  nextPageUrl: controller.upcomingPagination.value.nextPageUrl,
                  onViewAll: () {
                    Get.put(EventListController()).type.value="Upcoming Events";
                    Get.find<EventListController>().eventList=controller.upcomingEvents;
                    Get.find<EventListController>().paginationModel=controller.upcomingPagination;
                    Get.toNamed(Routes.EVENT_LIST);
                  },
                  showJoinButton: true,
                ),

              // Ongoing Events Section
              if (controller.ongoingEvents.isNotEmpty)
                _buildEventListSection(
                  title: "Ongoing Events",
                  events: controller.ongoingEvents,
                  nextPageUrl: controller.ongoingPagination.value.nextPageUrl,
                  onViewAll: () {
                    Get.put(EventListController()).type.value="Ongoing Events";
                    Get.find<EventListController>().eventList=controller.ongoingEvents;
                    Get.find<EventListController>().paginationModel=controller.ongoingPagination;
                    Get.toNamed(Routes.EVENT_LIST);
                  },
                  showJoinButton: true,
                ),

              // Expired Events Grid Section
              if (controller.expiredEvents.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: AppDimensions.widgetPadding.h),
                      SectionHeader(title: "Archive", showMoreButton: false),
                      SizedBox(height: AppDimensions.widgetPadding.h),
                    ],
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final event = controller.expiredEvents[index];
                    return RepaintBoundary(
                      child: Obx(() {
                        final isFav = controller.favouriteEvents.any(
                              (e) => e.id == event.id,
                        );
                        return EventGridItem(
                          eventName: event.title ?? "",
                          date: event.startDate ?? "",
                          duration: event.timeDifference ?? "",
                          image: event.image,
                          onTapDetails: () {
                            controller.getDetails(event: event);
                          },
                          onTapFavourite: () {
                            controller.addOrUpdateFavouriteEvent(event: event);
                          },
                          isFavourite: isFav.obs,
                        );
                      }),
                    );
                  }, childCount: controller.expiredEvents.length),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .7,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.sectionPadding.h),
                ),
              ],

              // Empty State
              if (isEmpty)
                SliverToBoxAdapter(
                  child: EmptyScreen(
                    message: 'No events available right now.',
                    icon: Icons.event_busy,
                  ),
                ),

              // Loading more indicator for expired events
              if (controller.isLoadingMore.value)
                SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
        if (controller.isUpdating.value) LoadingScreen(),
      ],
    );
  }

  /// Helper method to build Upcoming / Ongoing Event List Section
  Widget _buildEventListSection({
    required String title,
    required RxList<SingleEvent> events,
    required String? nextPageUrl,
    required VoidCallback onViewAll,
    bool showJoinButton = false,
  }) {
   // final controller = Get.find<EventsController>();
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionHeader(
            title: title,
            showMoreButton: nextPageUrl != null, // Only show "View All" if nextPageUrl exists
           onTapViewAll: onViewAll,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return  EventListItem(
                event: event,
                showJoinButton: true,
              );
            },
          ),
          SizedBox(height: AppDimensions.widgetPadding.h),
        ],
      ),
    );
  }

}

