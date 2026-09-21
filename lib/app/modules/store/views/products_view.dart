import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/productDetails/controllers/product_details_controller.dart';
import 'package:ontorikkho/app/modules/store/views/product_view_shimmer.dart';
import 'package:ontorikkho/app/modules/store/views/single_product_grid_view.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/section_header.dart';
import '../../../../common_widgets/sticky_header.dart';
import '../../../../constraints/app_colors.dart';
import '../controllers/store_controller.dart';

class ProductsView extends GetView<StoreController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          CustomScrollView(
            controller: controller.trackScrollController,
            slivers: [
              // Sticky Header
             /* SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  height: 30.sp,
                  child: SectionHeader(title: "Products", showMoreButton: false),
                ),
              ),*/
              if (controller.isLoadingProduct.value) ProductGridShimmer(),

              if (!controller.isLoadingProduct.value) ...[
                SliverPadding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: controller.products.length,
                      (context, index) {
                        final product = controller.products[index];
                        return RepaintBoundary(
                          child: Obx(() {
                            final isFav = controller.favouriteProducts.any(
                              (e) => e.id == product.id,
                            );
                            return ProductGridItem(

                              onAddToCart: () {
                                controller.getDetails(id: product.id.toString()).then((_) {
                                  final details = controller.productDetails.value.data;
                                  if (details == null) return;

                                  if (controller.colorGroup.isEmpty) {
                                    // Directly add to cart
                                    controller.addToCart(
                                      productId: details.id.toString(),
                                      title: details.name ?? "",
                                      imageUrl: details.productImage ?? "",
                                      price: double.tryParse(details.price ?? "0.0") ?? 0.0,
                                      quantity: 1,
                                      discountPrice: double.tryParse(details.discountPrice ?? "0.0"),
                                      afterDiscountPrice: details.afterDiscountPrice,
                                      availableQty: (details.totalQty??0).toString(),
                                    );
                                  } else {
                                    // Open custom bottom sheet for color/size/quantity
                                    showCustomBottomSheet(
                                      title: "Select Color, Size & Quantity",
                                      content: Obx(() {
                                        int selectedColorIndex = controller.selectedColorGroupIndex.value;
                                        int selectedSizeIndex = controller.selectedSizeIndex.value;
                                        int quantity = controller.quantity.value;

                                        final selectedColorGroup = controller.colorGroup[selectedColorIndex];
                                        final sizes = selectedColorGroup.sizes ?? [];

                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Color selector
                                            Wrap(
                                              spacing: 8,
                                              children: List.generate(controller.colorGroup.length, (i) {
                                                final colorName = controller.colorGroup[i].colorName ?? "";
                                                final isSelected = selectedColorIndex == i;
                                                return ChoiceChip(
                                                  label: Text(colorName),
                                                  selected: isSelected,
                                                  onSelected: (_) {
                                                    controller.selectedColorGroupIndex.value = i;
                                                    controller.selectedSizeIndex.value = 0;
                                                    controller.quantity.value = 1;
                                                  },
                                                );
                                              }),
                                            ),
                                            SizedBox(height: 12),

                                            // Size selector
                                            Wrap(
                                              spacing: 8,
                                              children: List.generate(sizes.length, (i) {
                                                final sizeName = sizes[i].sizeName ?? "";
                                                final isSelected = selectedSizeIndex == i;
                                                return ChoiceChip(
                                                  label: Text(sizeName),
                                                  selected: isSelected,
                                                  onSelected: (_) {
                                                    controller.selectedSizeIndex.value = i;
                                                    controller.quantity.value = 1;
                                                  },
                                                );
                                              }),
                                            ),
                                            SizedBox(height: 12),

                                            // Quantity selector
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: quantity > 1 ? () => controller.quantity.value-- : null,
                                                  icon: Icon(Icons.remove, color: quantity > 1 ? Colors.black : Colors.grey),
                                                ),
                                                Obx(() => Text(controller.quantity.value.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                                IconButton(
                                                  onPressed: () {
                                                    final maxQty = int.tryParse(sizes[selectedSizeIndex].qty ?? "0") ?? 1;
                                                    if (quantity < maxQty) controller.quantity.value++;
                                                  },
                                                  icon: Icon(Icons.add, color: quantity < (int.tryParse(sizes[selectedSizeIndex].qty ?? "0") ?? 1) ? Colors.black : Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),

                                            AppButton(
                                              onTap: () {
                                                final selectedSize = sizes[selectedSizeIndex];
                                                Get.back();
                                                controller.addToCart(
                                                  productId: details.id.toString(),
                                                  title: details.name ?? "",
                                                  imageUrl: details.productImage ?? "",
                                                  price: double.tryParse(details.price ?? "0.0") ?? 0.0,
                                                  quantity: controller.quantity.value,
                                                  discountPrice: double.tryParse(details.discountPrice ?? "0.0"),
                                                  afterDiscountPrice: details.afterDiscountPrice,
                                                  size: selectedSize.sizeName,
                                                  color: selectedColorGroup.colorName,
                                                  availableQty: selectedSize.qty??"0",
                                                );
                                                // Get.back(); -> bottom sheet stays open until user closes manually
                                              },
                                              text:"Add to Cart",
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



                              onWishTap: () {
                                controller.addOrUpdateFavouriteProduct(
                                  product: product,
                                );
                              },
                              onTap: () {
                                Get.put(
                                  ProductDetailsController(),
                                ).fetchData(id: product.id.toString());
                                Get.find<ProductDetailsController>()
                                    .quantity
                                    .value = 1;
                                Get.find<ProductDetailsController>()
                                    .selectedSizeIndex
                                    .value = 0;
                                Get.find<ProductDetailsController>()
                                    .selectedColorGroupIndex
                                    .value = 0;

                                Get.toNamed(Routes.PRODUCT_DETAILS);
                              },
                              product: product,
                              isFavourite: isFav.obs,
                            );
                          }),
                        );
                      },
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.60,
                      maxCrossAxisExtent: 300, // Adjust based on your layout
                    ),
                  ),
                ),

                if (controller.products.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyScreen(
                      message:
                          "No products available at the moment. Please check back later.",
                    ),
                  ),
                // Load more loader
                SliverToBoxAdapter(
                  child:
                      controller.isLoadingMoreProduct.value
                          ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
          if(controller.isUpdatingProduct.value)LoadingScreen()
        ],
      ),
    );
  }
}
