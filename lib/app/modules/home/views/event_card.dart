import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class EventCard extends StatelessWidget {
  final String image;
  final String date;
  final String duration;
  final String eventName;
  final String eventType;
  final VoidCallback? onTap; // New onTap callback

  const EventCard({
    super.key,
    required this.image,
    required this.date,
    required this.duration,
    required this.eventName,
    required this.eventType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Handle tap here
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          border: Border.all(color: const Color(0xffEBEEF2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: _buildEventDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.borderRadius.r)),
      child: CustomNetworkImage(
        image: image,
        height: 150.sp,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(text: eventName, size: 12),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyText(
              text: date,
              color: AppColors.primaryColor,
              size: 12,
            ),
            duration.isNotEmpty?BodyText(text: duration, size: 12):BodyText(text: eventType, size: 12),
          ],
        ),
      ],
    );
  }
}
