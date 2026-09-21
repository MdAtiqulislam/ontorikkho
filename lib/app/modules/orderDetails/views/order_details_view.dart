
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/status_badge.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true, title: "Order Details"),
      body: Obx(
            () => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _orderInfoCard(),
                  SizedBox(height: 18.h),

                  _sectionTitle("Items"),
                  SizedBox(height: 8.h),

                  _itemsList(),

                  SizedBox(height: 14.h),
                  Divider(),

                  _summaryCard(),

                  SizedBox(height: 20.h),

                  _sectionTitle("Shipping Address"),
                  SizedBox(height: 8.h),

                  _shippingCard(),

                  SizedBox(height: 25.h),
                ],
              ),
            ),

            if (controller.isLoading.value) const LoadingScreen(),
          ],
        ),
      ),
    );
  }

  // 🔵 Order Info card
  Widget _orderInfoCard() {
    final data = controller.order.value.data;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: "Order #${data?.orderNumber ?? ''}",
            size: 16,
          ),
          SizedBox(height: 4.h),

           StatusBadge(status: data?.orderStatus??"Unknown"),

          SizedBox(height: 6.h),

          BodyText(
            text: "Payment: ${data?.paymentStatus ?? 'N/A'} • ${data?.paymentMethod}",
            size: 12,
          ),

          BodyText(
            text: "Date: ${data?.createdAt?.toLocal().toString().substring(0, 16)}",
            size: 12,
          ),

          SizedBox(height: 10.h),

          Align(
            alignment: Alignment.centerRight,
            child: HeaderText(
              text: "৳${data?.total ?? '0'}",
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // 🔵 Items List
  Widget _itemsList() {
    final items = controller.order.value.data?.items ?? [];

    if (items.isEmpty) {
      return Text("No items found.");
    }

    return Container(
      decoration: _boxDecoration(), // Card decoration
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final product = item.product;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _productImage(product?.productImage),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(
                          text: product?.name ?? "",
                          size: 13,
                          maxLine: 2,
                        ),
                        SizedBox(height: 4.h),
                        if ((item.color != null && (item.color ?? "").isNotEmpty) ||
                            (item.size != null && (item.size ?? "").isNotEmpty))
                          BodyText(
                            text:
                            "Color: ${item.color ?? '-'}  •  Size: ${item.size ?? '-'}",
                            size: 11,
                          ),
                        SizedBox(height: 4.h),
                        _priceSection(product, item.quantity ?? 1),
                      ],
                    ),
                  ),
                ],
              ),

              // Divider between items except last one
              if (index != items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }



  // 🔵 Product image
  Widget _productImage(String? url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        url ?? "",
        width: 60.w,
        height: 60.w,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 40),
      ),
    );
  }

  // 🔵 Price section with discount
  Widget _priceSection(product, int qty) {
    final hasDiscount = ((double.tryParse(product?.discountPrice ?? "0") ?? 0) > 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasDiscount) ...[
          HeaderText(
            text: "$qty x ৳${product?.afterDiscountPrice}",
            size: 13,
          ),
          Text(
            "৳${product?.price}",
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 11.sp,
              color: Colors.grey,
            ),
          ),
        ] else ...[
          HeaderText(
            text: "$qty x ৳${product?.price}",
            size: 13,
          ),
        ],
      ],
    );
  }

  // 🔵 Summary Card
// 🔵 Summary Card
  Widget _summaryCard() {
    final data = controller.order.value.data;

    return Container(
      decoration: _boxDecoration(),
      padding: EdgeInsets.all(14.w),
      child: Column(
        children: [
          _summaryRow("Subtotal", "৳${data?.subtotal ?? '0'}"),

          // Discount → (-)৳amount
          _summaryRow(
            "Discount",
            "(-)৳${data?.discount ?? '0'}",
          ),

          // Delivery → (+)৳amount
          _summaryRow(
            "Delivery Charge",
            "(+)৳${data?.deliveryCharge ?? '0'}",
          ),

          Divider(),
          _summaryRow("Total", "৳${data?.total ?? '0'}", bold: true),
        ],
      ),
    );
  }


  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
          Text(
            value,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600),
          ),
        ],
      ),
    );
  }




  // 🔵 Shipping Card
  Widget _shippingCard() {
    final s = controller.order.value.data?.shippingAddress;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _boxDecoration(),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: s?.fullName ?? "N/A", size: 14),
          SizedBox(height: 6.h),
          BodyText(text: s?.phoneNo ?? "", size: 12),
          SizedBox(height: 6.h),
          BodyText(
            text:
            "${s?.streetAddress ?? ''}, ${s?.thana ?? ''}, ${s?.district ?? ''}, ${s?.division ?? ''}",
            size: 12,
            maxLine: 3,
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  // Box Decoration
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

}
