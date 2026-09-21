import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SinglePostShimmer extends StatelessWidget {
  const SinglePostShimmer({super.key});

  Widget shimmerBox({double? height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }

  Widget commentShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(height: 40.w, width: 40.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(height: 12.h, width: 120.w),
                SizedBox(height: 6.h),
                shimmerBox(height: 12.h),
                SizedBox(height: 4.h),
                shimmerBox(height: 12.h, width: 200.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// header
            Row(
              children: [
                shimmerBox(height: 40.w, width: 40.w),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(height: 12.h, width: 120.w),
                    SizedBox(height: 6.h),
                    shimmerBox(height: 10.h, width: 80.w),
                  ],
                )
              ],
            ),

            SizedBox(height: 20.h),

            /// post text
            shimmerBox(height: 12.h),
            SizedBox(height: 6.h),
            shimmerBox(height: 12.h),
            SizedBox(height: 6.h),
            shimmerBox(height: 12.h, width: 200.w),

            SizedBox(height: 20.h),

            /// media
            shimmerBox(height: 200.h),

            SizedBox(height: 20.h),

            /// actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                shimmerBox(height: 20.h, width: 50.w),
                shimmerBox(height: 20.h, width: 50.w),
                shimmerBox(height: 20.h, width: 50.w),
              ],
            ),

            SizedBox(height: 20.h),

            /// comments
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (_, __) => commentShimmer(),
            ),
          ],
        ),
      ),
    );
  }
}