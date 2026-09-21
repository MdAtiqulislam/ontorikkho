import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "My Cart"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.cartItems.isEmpty) {
          return EmptyScreen(message: 'Your cart is empty',animationPath: "assets/animations/nodata.json",);
          }

          return Stack(
            children: [
              ListView.separated(
                padding:  EdgeInsets.all(AppDimensions.widgetPadding.r),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) =>  SizedBox(height: AppDimensions.widgetPadding.h),
                itemBuilder: (context, index) {
                  final CartItemModel item = controller.cartItems[index];

                  final bool hasDiscount =
                      item.afterDiscountPrice != null &&
                          item.afterDiscountPrice!.isNotEmpty;

                  final double unitPrice = hasDiscount
                      ? double.tryParse(item.afterDiscountPrice!) ?? item.price
                      : item.price;

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    padding:  EdgeInsets.all(AppDimensions.contentPadding.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                          child: Image.network(
                            item.imageUrl,
                            width: 80.sp,
                            height: 80.sp,
                            fit: BoxFit.contain,
                          ),
                        ),
                         SizedBox(width: AppDimensions.widgetPadding.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                               SizedBox(height: AppDimensions.contentPadding.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '৳${unitPrice.toStringAsFixed(2)} x ${item.quantity} = ৳${(unitPrice * item.quantity).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (hasDiscount)
                                    Text(
                                      '৳${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                               SizedBox(height: AppDimensions.contentPadding.h),
                              Row(
                                children: [
                                  IgnorePointer(
                                    ignoring: item.quantity<=1 || controller.isLoading.value,
                                    child: IconButton(
                                      onPressed: () {
                                        controller.decrementQuantity(index);
                                        print(item.availableQuantity);
                                      },
                                      icon: const Icon(Icons.remove_circle_outline),
                                      color: item.quantity<=1?Colors.grey:Colors.black,
                                    ),
                                  ),
                                  Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                                  IgnorePointer(
                                    ignoring:controller.isLoading.value || int.parse(item.availableQuantity)<=item.quantity,
                                    child: IconButton(
                                      onPressed: () => controller.incrementQuantity(index),
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: int.parse(item.availableQuantity)<= item.quantity ?Colors.grey:Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  IgnorePointer(
                                    ignoring: controller.isLoading.value,
                                    child: TextButton(
                                      onPressed: () => controller.removeFromCart(index),
                                      child: const Text(
                                        'X Remove',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if(controller.isLoading.value)LoadingScreen()
            ],
          );
        }),
        bottomSheet: Obx(() => controller.cartItems.isNotEmpty
            ? Container(
          padding:  EdgeInsets.all(AppDimensions.widgetPadding.r),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ৳${controller.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppButton(
                height: 40.sp,
                onTap: () {
                  Get.toNamed(Routes.CHECKOUT);
                },
                text: "Checkout",
                bgColor: AppColors.primaryColor,
                showBorder: false,
              ),
            ],
          ),
        )

            : const SizedBox.shrink()),
      ),
    );
  }
}
