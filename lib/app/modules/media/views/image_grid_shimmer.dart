import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ImageGridShimmer extends StatelessWidget {
  final int itemCount;

  const ImageGridShimmer({this.itemCount = 8, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                // Image shimmer
                Positioned.fill(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Bottom gradient mimic
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 70.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black12,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ),

                // Download button shimmer
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(6.r),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 32.r,
                        height: 32.r,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: itemCount,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
