import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  Widget _buildShimmerBox({
    double height = 20,
    double width = double.infinity,
    double radius = 8,
  }) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }

  Widget _buildShimmerLine({double width = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: _buildShimmerBox(width: width.sw),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
          vertical: AppDimensions.verticalPadding.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            SizedBox(height: 20.h),
            ...List.generate(5, (_) => _buildShimmerLine(width: 1)),
            SizedBox(height: AppDimensions.sectionPadding.h),
            _buildShimmerBox(height: 40, width: 0.6.sw),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 40),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 40),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 40),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 40),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 60),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 60),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 40),
            SizedBox(height: AppDimensions.contentPadding.h),
            _buildShimmerBox(height: 40),
            SizedBox(height: AppDimensions.sectionPadding.h),
            Align(
              alignment: Alignment.center,
              child: _buildShimmerBox(height: 45, width: 0.4.sw, radius: 100),
            ),
          ],
        ),
      ),
    );
  }
}
