import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_circle_avatar.dart';

class OverlappingAvatars<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item) imageBuilder;
  final double size;
  final double overlap;
  final int maxShow;
  final double border;

  const OverlappingAvatars({
    super.key,
    required this.items,
    required this.imageBuilder,
    this.size = 20,
    this.overlap = 12,
    this.maxShow = 3,
    this.border = 3,
  });

  @override
  Widget build(BuildContext context) {
    final displayList = items.take(maxShow).toList();

    return SizedBox(
      width: (displayList.length * overlap + size).w,
      height: size.h,
      child: Stack(
        children: List.generate(displayList.length, (index) {
          final item = displayList[index];

          return Positioned(
            left: (index * overlap).w,
            child: CustomCircleAvatar(
              width: size.r,
              height: size.r,
              image: imageBuilder(item),
              border: border,
            ),
          );
        }),
      ),
    );
  }
}