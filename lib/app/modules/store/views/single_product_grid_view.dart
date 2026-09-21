import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';

import '../../../../models/single_product.dart';

class ProductGridItem extends StatelessWidget {
  final SingleProduct product;
  final VoidCallback? onWishTap;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;
  final RxBool? isFavourite;

  final bool showRemoveButton;
  final VoidCallback? onTapRemove;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.onWishTap,
    this.onTap,
    this.isFavourite,
    this.showRemoveButton = false,
    this.onTapRemove,
  });

  @override
  Widget build(BuildContext context) {
    final String name = product.name ?? "";
    final double price = double.parse(product.price ?? "0");
    final String discount = product.discountPrice ?? '0';
    final String afterDiscount = product.afterDiscountPrice ?? price.toString();
    final String imageUrl = product.productImage ?? '';
    final double rating = (product.productRating ?? 0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxHeight * 0.6;

        return Material(
          color: Colors.white,
          elevation: 3,
          shadowColor: AppColors.shadowColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
              ),
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + top-right button
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                        child: SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: CustomNetworkImage(
                            bgColor: Colors.grey.shade50,
                            image: imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: showRemoveButton
                            ? _buildRemoveButton()
                            : _buildFavouriteButton(),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  HeaderText(
                    text: name,
                    size: 12,
                    maxLine: 1,
                    resizeAble: false,
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    children: [
                      Icon(Icons.star, size: 12.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      BodyText(text: "$rating", size: 10, resizeAble: false),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    children: [
                      if (discount != '0')
                        Text(
                          "৳$price",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 10.spMin,
                          ),
                        ),
                      if (discount != '0') SizedBox(width: 4.w),
                      Text(
                        "৳$afterDiscount",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.spMin,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  AppButton(
                    text: "Add to Cart",
                    fontSize: 10,
                    verticalPadding: 4,
                    onTap: onAddToCart,
                    bgColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavouriteButton() {
    if (isFavourite == null || onWishTap == null) return const SizedBox.shrink();

    return Obx(() => Material(
      color: Colors.grey.shade300,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onWishTap,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Icon(
            isFavourite!.value ? Icons.favorite : Icons.favorite_border,
            size: 16.sp,
            color: isFavourite!.value ? Colors.red : Colors.grey,
          ),
        ),
      ),
    ));
  }

  Widget _buildRemoveButton() {
    return Material(
      color: Colors.grey.shade300,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTapRemove,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Icon(
            Icons.delete,
            size: 16.sp,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}


