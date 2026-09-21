/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_drop_down_field.dart';
import 'package:ontorikkho/common_widgets/custom_phone_field.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
   CheckoutView({super.key});

  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Checkout"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () => Stack(
            children: [
              bodyContent(),
              if (controller.isLoading.value) LoadingScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: Column(
        children: [
          addressSection(),
          paymentMethodSection(),
          orderSummarySection(),
          // termsAndConditionSection(),

          SizedBox(height: AppDimensions.sectionPadding.h,),
          AppButton(text: "Checkout",
              bgColor: AppColors.primaryColor,
              showBorder: false,
              onTap: (){

           if (_formKey.currentState?.validate()??false){
              controller.placeOrder();
           }

              }),
          SizedBox(height: AppDimensions.sectionPadding.h,)
        ],
      ),
    );
  }

   Widget addressSection() {
     final userData = controller.userData; // ধরে নিচ্ছি controller এ userData আছে

     return Card(
       child: Padding(
         padding: EdgeInsets.symmetric(
           horizontal: AppDimensions.horizontalPadding,
           vertical: AppDimensions.verticalPadding.h,
         ),
         child: Obx(
               () => Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 HeaderText(text: "Shipping Address"),
                 SizedBox(height: 8.h),

                 // ✅ Checkbox: Ship to different address
                 Row(
                   children: [
                     Obx(() => Checkbox(
                       value: controller.isDifferentAddress.value,
                       onChanged: (value) {
                         controller.toggleDifferentAddress();
                       },
                     )),
                     Expanded(
                       child: Text(
                         "Ship to a different address",
                         style: TextStyle(fontSize: 13.sp),
                       ),
                     ),
                   ],
                 ),

                 SizedBox(height: AppDimensions.widgetPadding.h),
                 CustomTextField(
                   hintText: "Enter full name",
                   title: "Full Name",
                   isRequired: true,
                   validatorText: "Required",
                   controller: controller.nameController,
                 ),
                 SizedBox(height: AppDimensions.contentPadding.h),

                 // ✅ Phone field
                 Obx(() {
                   if (controller.isCountryLoading.value) {
                     return const CircularProgressIndicator();
                   }

                   return CustomPhoneTextField(
                     title: "Phone Number",
                     isRequired: true,
                     selectedCountry: controller.selectedPhoneCountry.value,
                     callingCode:
                     controller.selectedPhoneCountry.value.callingCode ?? "",
                     controller: controller.phoneController,
                     onChange: (value) {
                       controller.selectedPhoneCountry.value = value!;
                     },
                   );
                 }),

                 SizedBox(height: AppDimensions.contentPadding.h),

                 // ✅ Division dropdown
                 CustomDropDownField(
                   title: "Division",
                   hintText: "Select Division",
                   isRequired: true,
                   validatorText: "Required",
                   itemList: controller.divisions.value,
                   value: controller.selectedDivision.value.isNotEmpty
                       ? controller.selectedDivision.value
                       : null,
                   onChange: (value) {
                     if (value != null) {
                       controller.selectedDistrict.value = "";
                       controller.selectedDivision.value = value;
                       controller.loadDistricts(division: value);
                     }
                   },
                 ),
                 SizedBox(height: AppDimensions.contentPadding.h),

                 // ✅ District dropdown
                 CustomDropDownField(
                   title: "District",
                   hintText: "Select District",
                   isRequired: true,
                   validatorText: "Required",
                   itemList: controller.districts.value,
                   value: controller.selectedDistrict.value.isNotEmpty
                       ? controller.selectedDistrict.value
                       : null,
                   onChange: (value) {
                     if (value != null) {
                       controller.selectedDistrict.value = value;
                       controller.loadUpazilas(district: value);
                     }
                   },
                 ),
                 SizedBox(height: AppDimensions.contentPadding.h),

                 CustomTextField(
                   title: "Upazilla/ Thana",
                   isRequired: true,
                   controller: controller.upazilaController,
                   validatorText: "Required",
                   hintText: "Enter Upazilla/ Thana",
                 ),
                 SizedBox(height: AppDimensions.contentPadding.h),

                 CustomTextField(
                   title: "Street Address",
                   hintText: "Street Address",
                   isRequired: true,
                   validatorText: "Required",
                   controller: controller.streetAddressController,
                   minLine: 2,
                   maxLine: 5,
                 ),
               ],
             ),
           ),
         ),
       ),
     );
   }


  Widget orderSummarySection() {
    final cartController = Get.put(CartController());

    return Obx(() {
      if (cartController.cartItems.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text("Your cart is empty")),
        );
      }

      // Calculate subtotal and discount
      double subtotal = 0;
      double discountTotal = 0;
       var deliveryCharge = controller.deliveryCharge.value;

      for (var item in cartController.cartItems) {
        double itemPrice = item.price;
        double discountedPrice =
            double.tryParse(item.afterDiscountPrice ?? '') ?? item.price;
        int quantity = item.quantity;

        subtotal += itemPrice * quantity;
        discountTotal += (itemPrice - discountedPrice) * quantity;
      }

      double total = subtotal - discountTotal + deliveryCharge;

      return Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
            vertical: AppDimensions.verticalPadding.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(text: "Order Summary"),
              SizedBox(height: AppDimensions.widgetPadding.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.cartItems.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final sellPrice =
                      double.tryParse(item.afterDiscountPrice ?? '') ??
                      item.price;
                  final actualPrice = item.price;
                  final discountAmount =
                      double.tryParse(item.discountPrice ?? "0") ?? 0;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                        child: Image.network(
                          item.imageUrl,
                          width: 50.sp,
                          height: 50.sp,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                        ),
                      ),
                       SizedBox(width: AppDimensions.widgetPadding.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyText(
                              text: item.title,
                              size: 12,
                              maxLine: 3,
                              align: TextAlign.start,
                            ),
                             SizedBox(height: AppDimensions.contentPadding.h),
                            BodyText(
                              text:"Quantity: ${item.quantity}",
                            ),
                          ],
                        ),
                      ),
                       SizedBox(width: AppDimensions.widgetPadding.w),
                      SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            HeaderText(
                              text:
                                  "৳${(sellPrice * item.quantity).toStringAsFixed(2)}",
                            ),
                            if (discountAmount > 0)
                              BodyText(
                                text: "৳${actualPrice.toStringAsFixed(2)}",
                                lineThrough: true,
                              ),
                            BodyText(
                              text: "($sellPrice X ${item.quantity})",
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(),
              Column(
                children: [
                  summaryRow("Subtotal", subtotal),
                  summaryRow("Discount", discountTotal),
                  summaryRow("Delivery Charge", deliveryCharge),
                  const Divider(),
                  summaryRow("Total", total, isTotal: true),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget summaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "৳${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentMethodSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
          vertical: AppDimensions.verticalPadding.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(text: "Payment Method"),
            RadioListTile(
                value: true,
                groupValue: true,
                title: HeaderText(text: "Cash on delivery"),
                secondary: Image.asset("assets/icons/cod.png",width: 30.sp,height: 30.sp,),
                onChanged: (value){},)
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_drop_down_field.dart';
import 'package:ontorikkho/common_widgets/custom_phone_field.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/cart/controllers/cart_controller.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  CheckoutView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CartController _cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil.init is called in app entry
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Checkout"),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(
              () => Stack(
            children: [
              _body(),
              if (controller.isLoading.value) const LoadingScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.h),
          _buildSectionCard(child: _addressForm(), padding: 16.w),
          SizedBox(height: 14.h),
          _buildSectionCard(child: _paymentMethod(), padding: 12.w),
          SizedBox(height: 14.h),
          _buildSectionCard(child: _orderSummary(), padding: 12.w),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: AppButton(
              text: "Checkout",
              bgColor: AppColors.primaryColor,
              showBorder: false,
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  controller.placeOrder();
                }
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ---------- Reusable Card wrapper ----------
  Widget _buildSectionCard({required Widget child, double padding = 12.0}) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(padding.w),
        child: child,
      ),
    );
  }

  // ---------- Address Form ----------
  Widget _addressForm() {
    return Form(
      key: _formKey,
      child: Obx(
            () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(text: "Shipping Address", color: AppColors.primaryColor, size: 16),
            SizedBox(height: 12.h),

            Row(
              children: [
                Checkbox(
                  value: controller.isDifferentAddress.value,
                  onChanged: (v) => controller.toggleDifferentAddress(),
                ),
                Expanded(
                  child: BodyText(text: "Ship to a different address", size: 13),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            CustomTextField(
              hintText: "Enter full name",
              title: "Full Name",
              isRequired: true,
              validatorText: "Required",
              controller: controller.nameController,
            ),
            SizedBox(height: 12.h),

            // Phone
            Obx(() {
              if (controller.isCountryLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return CustomPhoneTextField(
                title: "Phone Number",
                isRequired: true,
                selectedCountry: controller.selectedPhoneCountry.value,
                callingCode: controller.selectedPhoneCountry.value.callingCode ?? "",
                controller: controller.phoneController,
                onChange: (value) {
                  controller.selectedPhoneCountry.value = value;
                },
              );
            }),
            SizedBox(height: 12.h),

            CustomDropDownField(
              title: "Division",
              hintText: "Select Division",
              isRequired: true,
              validatorText: "Required",
              itemList: controller.divisions.value,
              value: controller.selectedDivision.value.isNotEmpty ? controller.selectedDivision.value : null,
              onChange: (value) {
                if (value != null) {
                  controller.selectedDistrict.value = "";
                  controller.selectedDivision.value = value;
                  controller.loadDistricts(division: value);
                }
              },
            ),
            SizedBox(height: 12.h),

            CustomDropDownField(
              title: "District",
              hintText: "Select District",
              isRequired: true,
              validatorText: "Required",
              itemList: controller.districts.value,
              value: controller.selectedDistrict.value.isNotEmpty ? controller.selectedDistrict.value : null,
              onChange: (value) {
                if (value != null) {
                  controller.selectedDistrict.value = value;
                  controller.loadUpazilas(district: value);
                }
              },
            ),
            SizedBox(height: 12.h),

            CustomTextField(
              title: "Upazilla / Thana",
              isRequired: true,
              controller: controller.upazilaController,
              validatorText: "Required",
              hintText: "Enter Upazilla/ Thana",
            ),
            SizedBox(height: 12.h),

            CustomTextField(
              title: "Street Address",
              hintText: "Street Address",
              isRequired: true,
              validatorText: "Required",
              controller: controller.streetAddressController,
              minLine: 2,
              maxLine: 4,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Payment Method ----------
  Widget _paymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(text: "Payment Method", color: AppColors.primaryColor, size: 16),
        SizedBox(height: 8.h),
        RadioListTile<bool>(
          value: true,
          groupValue: true,
          //activeColor: AppColors.primaryColor,
          title: HeaderText(text: "Cash on delivery", size: 14),
          secondary: Image.asset("assets/icons/cod.png", width: 40.sp, height: 40.sp),
          onChanged: (_) {},
        ),
      ],
    );
  }

  // ---------- Order Summary ----------
  Widget _orderSummary() {
    return Obx(() {
      final items = _cartController.cartItems;

      if (items.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Center(child: BodyText(text: "Your cart is empty")),
        );
      }

      double subtotal = 0;
      double discountTotal = 0;
      final double deliveryCharge = controller.deliveryCharge.value;

      for (var item in items) {
        final double original = item.price;
        final double sell = double.tryParse(item.afterDiscountPrice ?? '') ?? item.price;
        subtotal += original * item.quantity;
        discountTotal += (original - sell) * item.quantity;
      }

      final double total = subtotal - discountTotal + deliveryCharge;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Order Summary", color: AppColors.primaryColor, size: 16),
          SizedBox(height: 12.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            itemBuilder: (_, index) {
              final item = items[index];
              final sellPrice = double.tryParse(item.afterDiscountPrice ?? '') ?? item.price;
              final original = item.price;

              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                    child: Image.network(
                      item.imageUrl,
                      width: 55.sp,
                      height: 55.sp,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 30.sp),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(text: item.title, size: 13, maxLine: 2),
                        SizedBox(height: 6.h),
                        BodyText(text: "Quantity: ${item.quantity}", size: 12),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      HeaderText(text: "৳${(sellPrice * item.quantity).toStringAsFixed(2)}", size: 14),
                      if (original > sellPrice)
                        BodyText(text: "৳${original.toStringAsFixed(2)}", size: 11, lineThrough: true),
                    ],
                  )
                ],
              );
            },
          ),

          SizedBox(height: 12.h),
          Divider(color: Colors.grey.shade300),

          SizedBox(height: 8.h),

          _summaryRow("Subtotal", "৳${subtotal.toStringAsFixed(2)}"),
          _summaryRow("Discount", "(-)৳${discountTotal.toStringAsFixed(2)}"),
          _summaryRow("Delivery Charge", "(+)৳${deliveryCharge.toStringAsFixed(2)}"),

          SizedBox(height: 8.h),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 8.h),

          _summaryRow("Total", "৳${total.toStringAsFixed(2)}", isTotal: true),
        ],
      );
    });
  }

  // ---------- Summary Row ----------
  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(text: label, size: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500),
          BodyText(text: value, size: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600),
        ],
      ),
    );
  }
}
