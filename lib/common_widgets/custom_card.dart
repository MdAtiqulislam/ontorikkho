import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;
  final double blurRadius;
  final double? width;

  const CustomCard({
    super.key,
    required this.child,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.blurRadius=10,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:width ,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        boxShadow: [BoxShadow(blurRadius: blurRadius.r, color: AppColors.shadowColor)],
      ),
      child: child,
    );
  }
}
