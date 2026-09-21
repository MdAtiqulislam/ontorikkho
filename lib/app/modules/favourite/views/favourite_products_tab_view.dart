import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/favourite/controllers/favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:ontorikkho/app/modules/store/controllers/store_controller.dart';
import 'package:ontorikkho/app/modules/store/views/single_product_grid_view.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/custom_info_dialouge.dart';
import '../../../../common_widgets/empty_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../announcements/views/announcementShimmer.dart';
import '../../productDetails/controllers/product_details_controller.dart';

class FavouriteProductsTabView extends GetView<FavouriteController> {
  const FavouriteProductsTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          if (controller.isLoading.value) const AnnouncementShimmerList(),

          if (!controller.isLoading.value && controller.products.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = controller.products[index];
                  return RepaintBoundary(
                    child: Obx(() {
                      final isFav = controller.products.any(
                        (e) => e.id == product.id,
                      );
                      return ProductGridItem(
                        product: product,
                        onAddToCart: () {
                          StoreController storeController = Get.put(
                            StoreController(),
                          );

                          storeController.getDetails(id: product.id.toString()).then((
                            _,
                          ) {
                            final details =
                                storeController.productDetails.value.data;
                            if (details == null) return;

                            if (storeController.colorGroup.isEmpty) {
                              // Directly add to cart
                              storeController.addToCart(
                                productId: details.id.toString(),
                                title: details.name ?? "",
                                imageUrl: details.productImage ?? "",
                                price:
                                    double.tryParse(details.price ?? "0.0") ??
                                    0.0,
                                quantity: 1,
                                discountPrice: double.tryParse(
                                  details.discountPrice ?? "0.0",
                                ),
                                afterDiscountPrice: details.afterDiscountPrice,
                                availableQty: (details.totalQty??0).toString(),
                              );
                            } else {
                              // Open custom bottom sheet for color/size/quantity
                              showCustomBottomSheet(
                                title: "Select Color, Size & Quantity",
                                content: Obx(() {
                                  int selectedColorIndex =
                                      storeController
                                          .selectedColorGroupIndex
                                          .value;
                                  int selectedSizeIndex =
                                      storeController.selectedSizeIndex.value;
                                  int quantity = storeController.quantity.value;

                                  final selectedColorGroup =
                                      storeController
                                          .colorGroup[selectedColorIndex];
                                  final sizes = selectedColorGroup.sizes ?? [];

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Color selector
                                      Wrap(
                                        spacing: 8,
                                        children: List.generate(
                                          storeController.colorGroup.length,
                                          (i) {
                                            final colorName =
                                                storeController
                                                    .colorGroup[i]
                                                    .colorName ??
                                                "";
                                            final isSelected =
                                                selectedColorIndex == i;
                                            return ChoiceChip(
                                              label: Text(colorName),
                                              selected: isSelected,
                                              onSelected: (_) {
                                                storeController
                                                    .selectedColorGroupIndex
                                                    .value = i;
                                                storeController
                                                    .selectedSizeIndex
                                                    .value = 0;
                                                storeController.quantity.value =
                                                    1;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Size selector
                                      Wrap(
                                        spacing: 8,
                                        children: List.generate(sizes.length, (
                                          i,
                                        ) {
                                          final sizeName =
                                              sizes[i].sizeName ?? "";
                                          final isSelected =
                                              selectedSizeIndex == i;
                                          return ChoiceChip(
                                            label: Text(sizeName),
                                            selected: isSelected,
                                            onSelected: (_) {
                                              storeController
                                                  .selectedSizeIndex
                                                  .value = i;
                                              storeController.quantity.value =
                                                  1;
                                            },
                                          );
                                        }),
                                      ),
                                      SizedBox(height: 12),

                                      // Quantity selector
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed:
                                                quantity > 1
                                                    ? () =>
                                                        storeController
                                                            .quantity
                                                            .value--
                                                    : null,
                                            icon: Icon(
                                              Icons.remove,
                                              color:
                                                  quantity > 1
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              storeController.quantity.value
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final maxQty =
                                                  int.tryParse(
                                                    sizes[selectedSizeIndex]
                                                            .qty ??
                                                        "0",
                                                  ) ??
                                                  1;
                                              if (quantity < maxQty) {
                                                storeController
                                                    .quantity
                                                    .value++;
                                              }
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color:
                                                  quantity <
                                                          (int.tryParse(
                                                                sizes[selectedSizeIndex]
                                                                        .qty ??
                                                                    "0",
                                                              ) ??
                                                              1)
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),

                                      AppButton(
                                        onTap: () {
                                          final selectedSize =
                                              sizes[selectedSizeIndex];
                                          Get.back();
                                          storeController.addToCart(
                                            productId: details.id.toString(),
                                            title: details.name ?? "",
                                            imageUrl:
                                                details.productImage ?? "",
                                            price:
                                                double.tryParse(
                                                  details.price ?? "0.0",
                                                ) ??
                                                0.0,
                                            quantity:
                                                storeController.quantity.value,
                                            discountPrice: double.tryParse(
                                              details.discountPrice ?? "0.0",
                                            ),
                                            afterDiscountPrice:
                                                details.afterDiscountPrice,
                                            size: selectedSize.sizeName,
                                            color: selectedColorGroup.colorName,
                                            availableQty: selectedSize.qty??"0",
                                          );
                                          // Get.back(); -> bottom sheet stays open until user closes manually
                                        },
                                        text: "Add to Cart",
                                        bgColor: AppColors.primaryColor,
                                        showBorder: false,
                                      ),
                                    ],
                                  );
                                }),
                              );
                            }
                          });
                        },
                        showRemoveButton: true,
                        isFavourite: isFav.obs,
                        onTapRemove: () {
                          Get.dialog(
                            CustomInfoDialog(
                              title: "Attention",
                              description:
                                  "This item will remove from favourite list. Do you want to continue?",
                              onAccept: () {
                                controller.addOrUpdateFavouriteProduct(
                                  product: product,
                                );
                              },

                              acceptText: "Yes",
                              declineText: "No",
                            ),
                          );
                        },

                        onTap: () {
                          Get.put(
                            ProductDetailsController(),
                          ).fetchData(id: product.id.toString());
                          Get.find<ProductDetailsController>().quantity.value =
                              1;
                          Get.find<ProductDetailsController>()
                              .selectedSizeIndex
                              .value = 0;
                          Get.find<ProductDetailsController>()
                              .selectedColorGroupIndex
                              .value = 0;

                          Get.toNamed(Routes.PRODUCT_DETAILS);
                        },
                      );
                    }),
                  );
                }, childCount: controller.products.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.60,
                  maxCrossAxisExtent: 300, // Adjust based on your layout
                ),
              ),
            ),

          if (!controller.isLoading.value && controller.products.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: EmptyScreen(
                  message: "You don't have any favourite product.",
                    animationPath: "assets/animations/nodata.json"
                ),
              ),
            ),
        ],
      ),
    );
  }
}
