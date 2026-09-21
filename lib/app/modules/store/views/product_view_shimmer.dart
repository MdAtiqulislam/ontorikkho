import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGridShimmer extends StatelessWidget {
  final int itemCount;

  const ProductGridShimmer({this.itemCount = 6, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image box
                  Container(
                    height: 130.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Title box
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 6.h),
                  // Price box
                  Container(
                    height: 12.h,
                    width: 80.w,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 6.h),
                  // Button or other element
                  Container(
                    height: 30.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          childCount: itemCount,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.60,
          maxCrossAxisExtent: 300,
        ),
      ),
    );
  }
}
