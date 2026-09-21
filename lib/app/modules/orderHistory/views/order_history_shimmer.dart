import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryShimmer extends StatelessWidget {
  const OrderHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: order id and status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.w,
                            height: 16.h,
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            width: 80.w,
                            height: 16.h,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Product row
                      Row(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 14.h,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: 100.w,
                                  height: 14.h,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Bottom row: total and date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80.w,
                            height: 14.h,
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            width: 60.w,
                            height: 14.h,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: 5, // Number of shimmer cards
        ),
      ),
    );
  }
}
