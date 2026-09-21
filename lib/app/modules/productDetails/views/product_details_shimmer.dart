import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // Image Placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.grey,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Price Placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 20.h,
              width: 100.w,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 8.h),

          // Title Placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 18.h,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4.h),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 18.h,
              width: Get.width * 0.6,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 16.h),

          // Description Placeholder
          Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 12.h,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 16.h),

          // Button Placeholder
          Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 45.h,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 45.h,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
