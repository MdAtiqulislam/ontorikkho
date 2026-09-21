import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../../../constraints/expandable_text.dart';
import '../../controllers/product_details_controller.dart';

class DescriptionSection extends GetView<ProductDetailsController> {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderText(text: "Description"),
        ExpandableText(
          text: controller.productDetails.value.data?.description ?? "",
          fontSize: 12,
        ),
      ],
    );
  }
}
