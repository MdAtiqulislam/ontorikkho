import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class EventDetailsShimmer extends StatelessWidget {
  const EventDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.widgetPadding),
          _shimmerImage(),
          SizedBox(height: AppDimensions.widgetPadding.h),
          Row(
            children: [
              _shimmerCard(),
              SizedBox(width: AppDimensions.contentPadding.w),
              _shimmerCard(),
              SizedBox(width: AppDimensions.contentPadding.w),
              _shimmerCard(),
            ],
          ),
          SizedBox(height: AppDimensions.sectionPadding.h),
          _shimmerBox(height: 24.h, width: 200.w),
          SizedBox(height: 8.h),
          ...List.generate(
            5,
                (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: _shimmerBox(height: 12.h, width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _shimmerCard() {
    return Expanded(
      child: CustomCard(
        horizontalPadding: AppDimensions.contentPadding.w,
        verticalPadding: AppDimensions.contentPadding.h,
        blurRadius: 1,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Container(
                height: 12.h,
                width: 40.w,
                color: Colors.white,
              ),
              SizedBox(height: 8.h),
              Container(
                height: 10.h,
                width: 60.w,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }
}
