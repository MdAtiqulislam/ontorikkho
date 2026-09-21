import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constraints/dimensions.dart';

class PageListItemShimmer extends StatelessWidget {
  const PageListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.contentPadding.h,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Avatar
            Container(
              width: 70.r,
              height: 70.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(width: AppDimensions.widgetPadding.w),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Container(
                    width: 150.w,
                    height: 14.h,
                    color: Colors.white,
                  ),

                  SizedBox(height: 10.h),

                  /// Mutual avatars row
                  Row(
                    children: [
                      Container(
                        width: 24.r,
                        height: 24.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 24.r,
                        height: 24.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          height: 12.h,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}