import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PersonalDataShimmer extends StatelessWidget {
  const PersonalDataShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _shimmerBox(
            child: CircleAvatar(radius: 40.r),
          ),
          SizedBox(height: 16.h),
          _shimmerBox(
            height: 18.h,
            width: 140.w,
          ),
          SizedBox(height: 8.h),
          _shimmerBox(
            height: 14.h,
            width: 100.w,
          ),
          SizedBox(height: 8.h),
          _shimmerBox(
            height: 12.h,
            width: 80.w,
          ),
          SizedBox(height: 24.h),
          ...List.generate(7, (index) => _shimmerCard()),
        ],
      ),
    );
  }

  Widget _shimmerBox({double? width, double? height, Widget? child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child ??
          Container(
            width: width ?? double.infinity,
            height: height ?? 14.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
    );
  }

  Widget _shimmerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: _shimmerBox(
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
