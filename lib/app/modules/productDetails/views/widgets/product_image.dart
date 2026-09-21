import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/models/single_product.dart';
import '../../controllers/product_details_controller.dart';

class ProductImage extends GetView<ProductDetailsController> {
  const ProductImage({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Container(
        padding: EdgeInsets.all(AppDimensions.contentPadding.r),
        height: 350.sp,
        width: Get.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          color: Colors.white
        ),
        child: Stack(
          children: [
            CustomNetworkImage(
              image: controller.productDetails.value.data?.productImage ?? "",
              width: Get.width,
              localImage: "assets/images/moc_image_5.png",
              fit: BoxFit.contain,
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
                  onTap: () {
                    final data = controller.productDetails.value.data;
                    if (data == null) return; // Null check

                    final product = SingleProduct(
                      id: data.id,
                      description: data.description,
                      name: data.name,
                      price: data.price,
                      discountPrice: data.discountPrice,
                      afterDiscountPrice: data.afterDiscountPrice,
                      discountPercentage: data.discountPercentage,
                      productRating: data.productRating,
                      productImage: data.productImage,
                    );

                    controller.addOrUpdateFavouriteProduct(product: product);
                  },

                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        controller.isFav.value
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(Icons.favorite_border, color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
