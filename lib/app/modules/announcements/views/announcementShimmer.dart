import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AnnouncementShimmerList extends StatelessWidget {
  const AnnouncementShimmerList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8.h),
                    // Description lines
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 12.h,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12.h),
                    // Duration or footer line
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 80.w,
                        height: 10.h,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: itemCount,
      ),
    );
  }
}
