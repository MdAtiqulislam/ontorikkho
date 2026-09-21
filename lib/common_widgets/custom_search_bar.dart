import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';

import '../constraints/dimensions.dart';

class CustomSearchBar extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback? onTap;
  
  const CustomSearchBar({
    required this.title,
    required this.icon,
    this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SectionHeader(title: title, showMoreButton: false),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40.sp,
            width: 40.sp,
            margin: EdgeInsets.only(left: 8.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
