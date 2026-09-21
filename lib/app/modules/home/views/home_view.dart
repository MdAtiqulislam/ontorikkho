import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar_controller.dart';
import 'package:ontorikkho/app/modules/events/models/event_list_model.dart';
import 'package:ontorikkho/app/modules/home/views/announcement_card.dart';
import 'package:ontorikkho/app/modules/home/views/shimmer_screen.dart';
import 'package:ontorikkho/app/modules/home/views/two_factor_alart_card.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_list_tile.dart';
import 'package:ontorikkho/app/modules/home/views/membership_card.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/home_controller.dart';
import 'document_upload_reminder_card.dart';
import 'event_card.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(minimal: false, scaffoldKey: _scaffoldKey),
        drawer: MyDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
              () => controller.isLoading.value
              ? HomeScreenShimmer()
              : Stack(
            children: [
              RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  await controller.refreshHome();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.loggedInUserModel.value.is2faStatusCheck.toString() == "0") ...[
                          SizedBox(height: AppDimensions.widgetPadding.h),
                          TwoFAAlertCard(
                            onEnableTap: () {
                              Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
                            },
                          ),
                        ],

                        SizedBox(height: AppDimensions.widgetPadding.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText(text: 'WELCOME', size: 10),
                                HeaderText(
                                  text: controller.loggedInUserModel.value.name ?? "",
                                  size: 20,
                                ),
                              ],
                            ),
                            SizedBox(width: AppDimensions.widgetPadding.w),

                            controller.loggedInUserModel.value.subscriptionStatus == "Approved"
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                HeaderText(text: 'MEMBERSHIP ID', size: 10),
                                HeaderText(
                                  text: controller.loggedInUserModel.value.membershipId ?? "",
                                  size: 20,
                                ),
                              ],
                            )
                                : Expanded(
                              child: BodyText(
                                text:
                                "Your account is under review. We’ll notify you once it’s approved.",
                                align: TextAlign.end,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.sectionPadding.h),

                        if (controller.missingDocumentCount > 0 ||
                            controller.pendingDocumentCount > 0) ...[
                          DocumentUploadReminderCard(),
                          SizedBox(height: AppDimensions.sectionPadding.h),
                        ],

                        MembershipCard(),
                        SizedBox(height: AppDimensions.widgetPadding.h),


                        AppButton(
                          text: "Invite Friends",
                          onTap: () {
                            Get.toNamed(Routes.INVITE_FRIENDS);
                          },
                          bgColor: AppColors.primaryColor,
                          leading: Icon(Icons.person_add_alt_rounded,color: Colors.white,),
                        ),
                        SizedBox(height: AppDimensions.contentPadding.h),

                        SectionHeader(
                          title: "Events",
                          onTapViewAll: () {
                            Get.put(CustomBottomNavigationController()).selectedIndex.value = 1;
                            Get.toNamed(Routes.EVENTS);
                          },
                        ),

                        _buildEventSection(),

                        SizedBox(height: AppDimensions.widgetPadding.h),

                        SectionHeader(
                          title: "Announcements",
                          onTapViewAll: () {
                            Get.toNamed(Routes.ANNOUNCEMENTS);
                          },
                        ),

                        _buildAnnouncementSection(),

                        SizedBox(height: AppDimensions.widgetPadding.h),

                        SectionHeader(
                          title: "Discussion",
                          showMoreButton: false,
                          subTitle: "New members that need your approval",
                        ),

                        SizedBox(height: AppDimensions.widgetPadding.h),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.homeData.value.data?.pendingList?.length ?? 0,
                          itemBuilder: (buildContext, index) {
                            var pendingItem =
                            controller.homeData.value.data?.pendingList?[index];
                            return CustomListTile(
                              title: pendingItem?.name ?? "",
                              avatar: pendingItem?.profileImage ?? "",
                              trailing: AppButton(
                                text: "Approve",
                                onTap: () {
                                  controller.pendingUserApproval(id: (pendingItem?.id ?? "").toString());
                                },
                                verticalPadding: 5.h,
                                bgColor: AppColors.primaryColor,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: AppDimensions.widgetPadding.h),

                        if ((controller.homeData.value.data?.pendingList?.length ?? 0) >= 5) ...[
                          AppButton(
                            text: "View All",
                            onTap: () {
                              Get.toNamed(Routes.PENDING_LIST);
                            },
                            bgColor: AppColors.mutedText,
                            showBorder: false,
                          ),
                          SizedBox(height: AppDimensions.sectionPadding.h),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              if (controller.isUpdating.value) LoadingScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventSection() {
    return SizedBox(
      height: 240.sp,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.homeData.value.data?.events?.length ?? 0,
        itemBuilder: (context, index) {
          var event = controller.homeData.value.data?.events?[index];
          return EventCard(
            image: event?.image ?? "",
            date: event?.startDate ?? "",
            duration: event?.timeDifference ?? "",
            eventName: event?.title ?? "",
            eventType: event?.eventType??"",
            onTap: () {
              controller.getEventDetails(event: event ?? SingleEvent());
            },
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 10),
      ),
    );
  }

  Widget _buildAnnouncementSection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.homeData.value.data?.announcement?.length ?? 0,
      itemBuilder: (context, index) {
        var announcement =
        controller.homeData.value.data?.announcement?[index];

        return AnnouncementCard(
          title: announcement?.title ?? "",
          duration: announcement?.time ?? "",
          desc: announcement?.description ?? "",
        );
      },
      separatorBuilder: (_, __) => Padding(
        padding:  EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
        child: Divider(),
      ),
    );
  }
}
