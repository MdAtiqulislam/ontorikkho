import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../controllers/product_details_controller.dart';

class PriceSection extends GetView<ProductDetailsController> {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.productDetails.value.data;

    final discount = double.tryParse(product?.discountPrice ?? "0") ?? 0;
    final price = product?.price ?? "0";
    final afterDiscount = product?.afterDiscountPrice ?? price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BodyText(text: "Price", size: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            HeaderText(text: "৳$afterDiscount", size: 20),
            if (discount > 0) ...[
              const SizedBox(width: 6),
              BodyText(text: "৳$price", lineThrough: true, size: 11),
              const SizedBox(width: 6),
              _OfferBadge(
                offer: double.tryParse(product?.discountPercentage ?? "0") ?? 0,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _OfferBadge extends StatelessWidget {
  final double offer;
  const _OfferBadge({required this.offer});

  @override
  Widget build(BuildContext context) {
    if (offer <= 0) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [Color(0xffFEC00F), Color(0xFFFFE680)],
        ),
      ),
      child: HeaderText(text: "-$offer% Offer", size: 10),
    );
  }
}
