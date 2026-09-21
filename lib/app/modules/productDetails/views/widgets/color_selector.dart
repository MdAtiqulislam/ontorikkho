import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/header_text.dart';

import '../../../../../constraints/app_colors.dart';
import '../../../../../utils/util.dart';
import '../../controllers/product_details_controller.dart';
import 'size_selector.dart';

class ColorSelector extends GetView<ProductDetailsController> {
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.colorGroup.isEmpty) return const SizedBox();

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
          const SizeSelector(),
        ],
      );
    });
  }
}
