import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/eventDetails/views/event_details_shimmer.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

import '../controllers/event_details_controller.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:  CustomAppBar(
          showBackButton: true,
          title: "Event Details",
        ),

        bottomNavigationBar:  CustomBottomNavigationBar(),

        floatingActionButton: Obx(() {
          final data = controller.eventDetails.value.data;
          final isLoading = controller.isLoading.value;

          /// If event not expired & not loading → show button
          if (data?.eventType != "expired" && !isLoading) {
            return SizedBox(
              height: 42.h,
              width: 160.w,
              child: AppButton(
                text: "Join Event",
                bgColor: AppColors.primaryColor,
                showBorder: false,
                onTap: controller.joinEvent,
              ),
            );
          }

          return const SizedBox.shrink();
        }),

        body: Obx(() {
          return controller.isLoading.value
              ? const EventDetailsShimmer()
              : _buildBody();
        }),
      ),
    );
  }

  // --------------------------
  // Build Main Body
  // --------------------------
  Widget _buildBody() {
    final data = controller.eventDetails.value.data;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.widgetPadding),

          _buildImage(data?.image),

          SizedBox(height: AppDimensions.widgetPadding.h),

          _buildInfoRow(data),

          SizedBox(height: AppDimensions.sectionPadding.h),

          /// Title
          HeaderText(
            text: data?.title ?? "",
            maxLine: 3,
          ),

          /// HTML Description
          SizedBox(height: AppDimensions.contentPadding.h,),
          Html(
            data: data?.description ?? "",
            style: {
              "html": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14.sp),
                color: AppColors.bodyText,
                textAlign: TextAlign.justify,
              ),
              "p": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
            },
          ),


          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  // --------------------------
  // Image Section
  // --------------------------
  Widget _buildImage(String? imageUrl) {
    return Container(
      height: 240.h,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      ),
      child: Stack(
        children: [
          CustomNetworkImage(
            image: imageUrl ?? "",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black26),
        ],
      ),
    );
  }

  // --------------------------
  // Build Info Row
  // --------------------------
  Widget _buildInfoRow(data) {
    return Row(
      children: [
        _buildInfoCard(
          icon: Icons.calendar_month,
          level: "Date",
          value: data?.startDate ?? "",
        ),
        SizedBox(width: AppDimensions.contentPadding.w),
        _buildInfoCard(
          icon: Icons.timer_sharp,
          level: "Time",
          value: data?.time ?? "",
        ),
        SizedBox(width: AppDimensions.contentPadding.w),
        _buildInfoCard(
          icon: Icons.location_on_outlined,
          level: "Location",
          value: data?.location ?? "",
        ),
      ],
    );
  }

  // --------------------------
  // Info Card
  // --------------------------
  Widget _buildInfoCard({
    required IconData icon,
    required String level,
    required String value,
  }) {
    return Expanded(
      child: CustomCard(
        horizontalPadding: AppDimensions.contentPadding.w,
        verticalPadding: AppDimensions.contentPadding.h,
        blurRadius: 1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14.sp, color: AppColors.bodyText),
                SizedBox(width: AppDimensions.contentPadding.w),
                BodyText(text: level, size: 10),
              ],
            ),
            SizedBox(height: (AppDimensions.contentPadding / 2).h),
            HeaderText(text: value, size: 10),
          ],
        ),
      ),
    );
  }
}
