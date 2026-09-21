/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/productDetails/views/product_details_shimmer.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/expandable_text.dart';
import '../../../../utils/util.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Product Details", showBackButton: true),
        bottomNavigationBar: SizedBox(
            height: 50,
            child: customBottomNavBar()
        ),


        body: Obx(() {
          if (controller.isLoading.value) return ProductDetailsShimmer();
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    _buildImage(),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BodyText(text: "Price", size: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  (double.tryParse(
                                    (controller
                                        .productDetails
                                        .value
                                        .data
                                        ?.discountPrice ??
                                        "0.0"),
                                  ) ??
                                      0) >
                                      0
                                      ? HeaderText(
                                    text:
                                    "৳${controller.productDetails.value.data
                                        ?.afterDiscountPrice}",
                                    size: 20,
                                  )
                                      : HeaderText(
                                    text:
                                    "৳${controller.productDetails.value.data
                                        ?.price}",
                                  ),
                                  SizedBox(
                                    width: AppDimensions.contentPadding.w,
                                  ),
                                  if ((double.tryParse(
                                    (controller
                                        .productDetails
                                        .value
                                        .data
                                        ?.discountPrice ??
                                        "0.0"),
                                  ) ??
                                      0) >
                                      0) ...[
                                    BodyText(
                                      text:
                                      "৳${controller.productDetails.value.data
                                          ?.price}",
                                      lineThrough: true,
                                      size: 11,
                                    ),
                                    SizedBox(
                                      width: AppDimensions.contentPadding.w,
                                    ),
                                    _buildOfferCard(
                                      subTitle: "offer",
                                      offer:
                                      double.tryParse(
                                        (controller
                                            .productDetails
                                            .value
                                            .data
                                            ?.discountPercentage) ??
                                            "0",
                                      ) ??
                                          0,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.warningColor,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${controller.productDetails.value.data
                                  ?.productRating ?? "0"}",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    HeaderText(
                      text: controller.productDetails.value.data?.name ?? "",
                      maxLine: 3,
                      align: TextAlign.start,
                    ),

                    SizedBox(height: AppDimensions.widgetPadding.h,),
                    if (controller.colorGroup.isNotEmpty) _buildColorGroup(),

                    SizedBox(height: AppDimensions.widgetPadding.h),
                    HeaderText(text: "Description"),
                    ExpandableText(
                      text: controller.productDetails.value.data?.description ??
                          "",
                      fontSize: 12,
                    ),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                  ],
                ),
              ),
              if (controller.isUpdating.value) LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImage() {
    return Obx(
          () =>
          Container(
            height: 200.h,
            width: Get.width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            ),
            child: Stack(
              children: [
                CustomNetworkImage(
                  image: controller.productDetails.value.data?.productImage ??
                      "",
                  width: Get.width,
                  localImage: "assets/images/moc_image_5.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Material(
                    color: Colors.black45,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      splashColor: Colors.red,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildOfferCard({required String subTitle, required double offer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (offer > 0)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.contentPadding.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
              gradient: const LinearGradient(
                colors: [Color(0xffFEC00F), Color(0xFFFFE680)],
              ),
            ),
            child: HeaderText(text: "-$offer% Offer", size: 10),
          ),
      ],
    );
  }

  Widget _buildColorGroup() {
    return Obx(() {
      final selectedColorIndex = controller.selectedColorGroupIndex.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Color"),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.colorGroup.length,
              itemBuilder: (context, index) {
                final isSelected = selectedColorIndex == index;

                return InkWell(
                  onTap: () {
                    controller.selectColor(index);
                    controller.selectedSizeIndex.value=0;
                    controller.quantity.value=1;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black,
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? AppColors.primaryColor.withAlpha(20)
                            : Colors.black12,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(2),
                        color: getColorFromName(
                            controller.colorGroup[index].colorName ?? ""),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          _buildSizeGroup(), // reactive version
        ],
      );
    });
  }

  Widget _buildSizeGroup() {
    return Obx(() {
      final sizes = controller.selectedSizes;
      final selectedSizeIndex = controller.selectedSizeIndex.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Size"),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sizes.length,
              itemBuilder: (context, index) {
                final isSelected = selectedSizeIndex == index;

                return InkWell(
                  onTap: () {
                    controller.selectSize(index);
                    controller.quantity.value=1;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black,
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? AppColors.primaryColor.withAlpha(20)
                            : Colors.white,
                      ),
                      child: Center(
                        child: HeaderText(text: sizes[index].sizeName ?? ""),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget customBottomNavBar() {
   return Obx((){
      if (controller.colorGroup.isEmpty) return mainProductCartButton();
      return colorGroupCartButton();
    });
  }

  Widget mainProductCartButton() {
    return (int.tryParse(
        controller.productDetails.value.data?.totalQty ?? "0") ?? 0) > 0
        ? inStockButton(quantity:(int.tryParse(
        controller.productDetails.value.data?.totalQty ?? "0") ?? 0)  )
        : AppButton(text: "Out of Stock",
      onTap: () {},
      bgColor: Colors.red,
      showBorder: false,);
  }

  Widget colorGroupCartButton() {
    return (int.tryParse((controller.colorGroup[controller.selectedColorGroupIndex.value]
        .sizes?[controller.selectedSizeIndex.value].qty??"0"))??0)>0
        ?inStockButton(quantity:(int.tryParse((controller.colorGroup[controller.selectedColorGroupIndex.value]
        .sizes?[controller.selectedSizeIndex.value].qty??"0"))??0))
        :AppButton(text: "Out of Stock", onTap: (){});

  }

  Widget inStockButton({required int quantity}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // quantity কমানোর লজিক
                  if (controller.quantity.value > 1) {
                    controller.quantity.value--;
                  }
                },
                icon: Icon(Icons.remove, color: AppColors.mutedButton),
              ),
              Obx(() =>
                  Text(
                    controller.quantity.value.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              IconButton(
                onPressed: () {
                  // quantity বাড়ানোর লজিক
                  if(quantity>controller.quantity.value)controller.quantity.value++;
                },
                icon: Icon(Icons.add, color: AppColors.mutedButton),
              ),
            ],
          ),
        ),
        SizedBox(width: AppDimensions.widgetPadding.w),
        Expanded(
          child: AppButton(
            text: "Add to Cart",
            onTap: () {
              // add to cart লজিক
            },
            bgColor: AppColors.primaryColor,
            showBorder: false,
          ),
        ),
      ],
    );
  }
}
*/


/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/productDetails/views/product_details_shimmer.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/expandable_text.dart';
import '../../../../utils/util.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  int _parseInt(String? value) => int.tryParse(value ?? "0") ?? 0;
  double _parseDouble(String? value) => double.tryParse(value ?? "0.0") ?? 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:  CustomAppBar(title: "Product Details", showBackButton: true),
        bottomNavigationBar: SizedBox(height: 50, child: customBottomNavBar()),
        body: Obx(() {
          if (controller.isLoading.value) return const ProductDetailsShimmer();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    _buildImage(),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                    _buildPriceSection(),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    HeaderText(
                      text: controller.productDetails.value.data?.name ?? "",
                      maxLine: 3,
                      align: TextAlign.start,
                    ),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    if (controller.colorGroup.isNotEmpty) _buildColorGroup(),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    const HeaderText(text: "Description"),
                    ExpandableText(
                      text: controller.productDetails.value.data?.description ?? "",
                      fontSize: 12,
                    ),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                  ],
                ),
              ),
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImage() {
    return Obx(
          () => Container(
        height: 200.h,
        width: Get.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        ),
        child: Stack(
          children: [
            CustomNetworkImage(
              image: controller.productDetails.value.data?.productImage ?? "",
              width: Get.width,
              localImage: "assets/images/moc_image_5.png",
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Material(
                color: Colors.black45,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: Colors.red,
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    final data = controller.productDetails.value.data;
    final discount = _parseDouble(data?.discountPrice);
    final price = _parseDouble(data?.price);
    final afterDiscount = _parseDouble(data?.afterDiscountPrice);
    final discountPercent = _parseDouble(data?.discountPercentage);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(text: "Price", size: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  HeaderText(
                    text: "৳${discount > 0 ? afterDiscount : price}",
                    size: 20,
                  ),
                  SizedBox(width: AppDimensions.contentPadding.w),
                  if (discount > 0) ...[
                    BodyText(
                      text: "৳$price",
                      lineThrough: true,
                      size: 11,
                    ),
                    SizedBox(width: AppDimensions.contentPadding.w),
                    _buildOfferCard(offer: discountPercent),
                  ],
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Icon(Icons.star, color: AppColors.warningColor, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              data?.productRating ?? "0",
              style: TextStyle(fontSize: 12.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOfferCard({required double offer}) {
    if (offer <= 0) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.contentPadding.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        gradient: const LinearGradient(
          colors: [Color(0xffFEC00F), Color(0xFFFFE680)],
        ),
      ),
      child: HeaderText(text: "-$offer% Offer", size: 10),
    );
  }

  Widget _buildColorGroup() {
    return Obx(() {
      final selectedColorIndex = controller.selectedColorGroupIndex.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Color"),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.colorGroup.length,
              itemBuilder: (context, index) {
                final isSelected = selectedColorIndex == index;
                return InkWell(
                  onTap: () {
                    controller.selectColor(index);
                    controller.selectedSizeIndex.value = 0;
                    controller.quantity.value = 1;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black,
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? AppColors.primaryColor.withAlpha(20)
                            : Colors.black12,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        color: getColorFromName(
                          controller.colorGroup[index].colorName ?? "",
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSizeGroup(),
        ],
      );
    });
  }

  Widget _buildSizeGroup() {
    return Obx(() {
      final sizes = controller.selectedSizes;
      final selectedSizeIndex = controller.selectedSizeIndex.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Size"),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sizes.length,
              itemBuilder: (context, index) {
                final isSelected = selectedSizeIndex == index;
                return InkWell(
                  onTap: () {
                    controller.selectSize(index);
                    controller.quantity.value = 1;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black,
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? AppColors.primaryColor.withAlpha(20)
                            : Colors.white,
                      ),
                      child: Center(
                        child: HeaderText(text: sizes[index].sizeName ?? ""),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  /// ------------------- Bottom NavBar -------------------

  Widget customBottomNavBar() {
    return Obx(() {
      final data = controller.productDetails.value.data;

      if (controller.colorGroup.isEmpty) {
        final totalQty = _parseInt(data?.totalQty);
        return _buildCartSection(totalQty);
      }

      final selectedColor =
      controller.colorGroup[controller.selectedColorGroupIndex.value];
      final sizeQty = _parseInt(
          selectedColor.sizes?[controller.selectedSizeIndex.value].qty);

      return _buildCartSection(sizeQty);
    });
  }

  Widget _buildCartSection(int availableQty) {
    return availableQty > 0
        ? _inStockButton(maxQty: availableQty)
        : AppButton(
      text: "Out of Stock",
      onTap: () {},
      bgColor: Colors.red,
      showBorder: false,
    );
  }

  Widget _inStockButton({required int maxQty}) {
    return Row(
      children: [
        Expanded(
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.quantity.value > 1) {
                      controller.quantity.value--;
                    }
                  },
                  icon: Icon(Icons.remove, color: AppColors.mutedButton),
                ),
                Text(
                  controller.quantity.value.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.quantity.value < maxQty) {
                      controller.quantity.value++;
                    }
                  },
                  icon: Icon(Icons.add, color: AppColors.mutedButton),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppDimensions.widgetPadding.w),
        Expanded(
          child: AppButton(
            text: "Add to Cart",
            onTap: () {
              // TODO: addToCart logic
            },
            bgColor: AppColors.primaryColor,
            showBorder: false,
          ),
        ),
      ],
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/productDetails/controllers/product_details_controller.dart';
import 'package:ontorikkho/app/modules/productDetails/views/product_details_shimmer.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'widgets/product_image.dart';
import 'widgets/price_section.dart';
import 'widgets/rating_section.dart';
import 'widgets/color_selector.dart';
import 'widgets/description_section.dart';
import 'widgets/bottom_navbar.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:  CustomAppBar(title: "Product Details", showBackButton: true),
        bottomNavigationBar: const BottomNavbar(),
        body: Obx(() {
          if (controller.isLoading.value) return const ProductDetailsShimmer();
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    const ProductImage(),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: PriceSection()),
                        RatingSection(),
                      ],
                    ),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    HeaderText(
                      text: Get.find<ProductDetailsController>()
                          .productDetails
                          .value
                          .data
                          ?.name ??
                          "",
                      maxLine: 3,
                      align: TextAlign.start,
                    ),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    const ColorSelector(),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    const DescriptionSection(),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                  ],
                ),
              ),
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}
