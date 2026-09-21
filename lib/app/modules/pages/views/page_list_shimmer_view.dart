import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constraints/dimensions.dart';
import '../widgets/page_list_item_shimmer.dart';


class PagesListShimmerView extends StatelessWidget {
  const PagesListShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
        vertical: AppDimensions.widgetPadding.h,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return const PageListItemShimmer();
      },
    );
  }
}