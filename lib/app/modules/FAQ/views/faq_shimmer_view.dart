import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class FAQShimmerList extends StatelessWidget {
  const FAQShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
        vertical: AppDimensions.verticalPadding.h,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppDimensions.contentPadding.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            color: const Color(0xffF5F5F5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 16.h,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 12.h,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
