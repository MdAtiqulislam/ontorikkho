import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../constraints/app_colors.dart';
import '../../controllers/product_details_controller.dart';

class RatingSection extends GetView<ProductDetailsController> {
  const RatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: AppColors.warningColor, size: 16.sp),
        SizedBox(width: 4.w),
        Text(
          "${controller.productDetails.value.data?.productRating ?? "0"}",
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    );
  }
}
