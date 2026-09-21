import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/header_text.dart';

import '../../../../../constraints/app_colors.dart';
import '../../controllers/product_details_controller.dart';

class SizeSelector extends GetView<ProductDetailsController> {
  const SizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
}
