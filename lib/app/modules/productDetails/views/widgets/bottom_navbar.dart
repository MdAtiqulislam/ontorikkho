import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../../constraints/app_colors.dart';
import '../../controllers/product_details_controller.dart';

class BottomNavbar extends GetView<ProductDetailsController> {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Obx(() {
        // 🔹 Step 1: Loading হলে কিছুই দেখাবে না
        if (controller.isLoading.value) {
          return const SizedBox.shrink();
        }

        // 🔹 Step 2: ডেটা এখনো null হলে কিছুই দেখাবে না
        if (controller.productDetails.value.data == null) {
          return const SizedBox.shrink();
        }

        // 🔹 Step 3: colorGroup আছে কিনা চেক
        if (controller.colorGroup.isEmpty) {
          return _mainProductCartButton();
        }
        return _colorGroupCartButton();
      }),
    );
  }

  Widget _mainProductCartButton() {
    final stockStr = controller.productDetails.value.data?.totalQty;

    if (stockStr == null) return const SizedBox.shrink();

    final stock = stockStr;

    return stock > 0
        ? _inStockButton(quantity: stock)
        : AppButton(
      text: "Out of Stock",
      onTap: () {},
      bgColor: Colors.red,
      showBorder: false,
    );
  }

  Widget _colorGroupCartButton() {
    // color group stock চেক
    final stockStr = controller.colorGroup[controller.selectedColorGroupIndex.value]
        .sizes?[controller.selectedSizeIndex.value].qty;

    if (stockStr == null) return const SizedBox.shrink();

    final stock = int.tryParse(stockStr) ?? 0;

    return stock > 0
        ? _inStockButton(quantity: stock)
        : AppButton(
      text: "Out of Stock",
      onTap: () {},
      bgColor: Colors.red,
      showBorder: false,
    );
  }

  Widget _inStockButton({required int quantity}) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final currentQty = controller.quantity.value;
            final canDecrease = currentQty > 1;
            final canIncrease = currentQty < quantity;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: canDecrease ? () => controller.quantity.value-- : null,
                  icon: Icon(
                    Icons.remove,
                    color: canDecrease ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  currentQty.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: canIncrease ? () => controller.quantity.value++ : null,
                  icon: Icon(
                    Icons.add,
                    color: canIncrease ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(width: AppDimensions.widgetPadding.w),
        Expanded(
          child: AppButton(
            text: "Add to Cart",
            onTap: () {
              controller.addToCart();
            },
            bgColor: AppColors.primaryColor,
            showBorder: false,
          ),
        ),
      ],
    );
  }
}
