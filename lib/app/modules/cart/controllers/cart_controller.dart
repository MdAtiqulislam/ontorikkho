import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  var isLoading = false.obs;


  late Box<CartItemModel> _cartBox;
  var cartItems = <CartItemModel>[].obs;

  int get cartItemCount => cartItems.length;

  @override
  void onInit() {
    super.onInit();
    _cartBox = Hive.box<CartItemModel>('cartBox');
    fetchCartFromServer();
  }

  // -----------------------------------------------------------------------------
  // 🔹 Fetch cart from server → Save to Hive
  // -----------------------------------------------------------------------------
  Future<void> fetchCartFromServer() async {
    isLoading.value = true;

    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getCartData);

      if (res != null && res['status'] == true) {
        final List data = res['data'];
        await _cartBox.clear();

        for (var item in data) {
          final product = item['product'];

          final cartItem = CartItemModel(
            productId: item['product_id'].toString(),
            title: product['name'] ?? '',
            imageUrl: product['product_image'] ?? '',
            price: double.tryParse(item['unit_price'] ?? '0') ?? 0,
            quantity: item['quantity'] ?? 1,
            size: item['size'],
            color: item['color'],
            discountPrice: product['discount_price'],
            afterDiscountPrice: product['after_discount_price'],
            availableQuantity: product["total_qty"].toString(),
          );

          await _cartBox.add(cartItem);
        }

        loadCartItems();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      print(e.toString());
      CustomSnackBar(isSuccess: false, msg: e.toString()).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  void loadCartItems() {
    cartItems.value = _cartBox.values.toList();
  }

  // -----------------------------------------------------------------------------
// 🔹 Add Item To Cart (Server First + Local Update + Button Disable)
// -----------------------------------------------------------------------------
  Future<void> addToCart({
    required String productId,
    required String title,
    required String imageUrl,
    required double price,
    required int quantity,
    required String availableQuantity,
    double? discountPrice,
    String? afterDiscountPrice,
    String? size,
    String? color,
  }) async {
    isLoading.value = true; // global loading for add button

    final newItem = CartItemModel(
      productId: productId,
      title: title,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity,
      discountPrice: discountPrice?.toString(),
      afterDiscountPrice: afterDiscountPrice,
      size: size,
      color: color,
      availableQuantity: availableQuantity,
    );

    // 🔍 Check if already exists (same product + attributes)
    final index = _cartBox.values.toList().indexWhere(
          (e) => e.productId == productId && e.size == size && e.color == color,
    );

    try {
      if (index != -1) {
        // Already exists → update qty
        final existing = _cartBox.getAt(index);
        if (existing == null) return;

        final updatedQty = existing.quantity + quantity;

        final res = await RemoteServices.postRequest(
          endpoint: APIEndPoints.addToCart,
          body: {
            "product_id": productId,
            "quantity": updatedQty.toString(),
            "unit_price": price.toString(),
            "color": color ?? "",
            "size": size ?? "",
          },
        );

        if (res != null) {
          existing.quantity = updatedQty;
          await _cartBox.putAt(index, existing);
          loadCartItems();
          CustomSnackBar(isSuccess: true, msg: "Quantity updated").showSnackBar();
        } else {
          CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
        }
      } else {
        // Brand new product → add
        final res = await RemoteServices.postRequest(
          endpoint: APIEndPoints.addToCart,
          body: {
            "product_id": productId,
            "quantity": quantity.toString(),
            "unit_price": price.toString(),
            "color": color ?? "",
            "size": size ?? "",
          },
        );

        if (res != null) {
          await _cartBox.add(newItem);
          loadCartItems();
          CustomSnackBar(isSuccess: true, msg: "Added to cart").showSnackBar();
        } else {
          CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
        }
      }
    } catch (e) {
      CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }



  // -----------------------------------------------------------------------------
  // 🔹 Increment Quantity (with loading & button disable)
  // -----------------------------------------------------------------------------
  Future<void> incrementQuantity(int index) async {
    final item = _cartBox.getAt(index);
    if (item == null) return;

    isLoading.value = true;

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.incrementCart,
        body: {
          "product_id": item.productId,
          "quantity": "1",
          "color": item.color ?? "",
          "size": item.size ?? "",
        },
      );

      if (res != null) {
        item.quantity += 1;
        await _cartBox.putAt(index, item);
        loadCartItems();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }


  }

  // -----------------------------------------------------------------------------
  // 🔹 Decrement Quantity (with loading & disable)
  // -----------------------------------------------------------------------------
  Future<void> decrementQuantity(int index) async {
    final item = _cartBox.getAt(index);
    if (item == null) return;

    if (item.quantity == 1) {
      await removeFromCart(index);
      return;
    }

    isLoading.value = true;

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.decrementCart,
        body: {
          "product_id": item.productId,
          "quantity": "1",
          "color": item.color ?? "",
          "size": item.size ?? "",
        },
      );
      
      if (res != null) {
        item.quantity -= 1;
        await _cartBox.putAt(index, item);
        loadCartItems();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }

    //itemLoading[index] = false;
  }

  // -----------------------------------------------------------------------------
  // 🔹 Remove Item (with loading)
  // -----------------------------------------------------------------------------
  Future<void> removeFromCart(int index) async {
    final item = _cartBox.getAt(index);
    if (item == null) return;

  isLoading.value = true;

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.removeCart,
        body: {
          "product_id": item.productId,
          "color":item.color??"",
          "size":item.size??""
        },
      );
      
      if (res != null) {
        await _cartBox.deleteAt(index);
        loadCartItems();
        CustomSnackBar(isSuccess: true, msg: "Item removed").showSnackBar();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }

   // itemLoading[index] = false;
  }

  // -----------------------------------------------------------------------------
  // 🔹 Total Price Calculation
  // -----------------------------------------------------------------------------
  double get totalPrice => cartItems.fold(
    0,
        (total, item) {
      final price =
          double.tryParse(item.afterDiscountPrice ?? '') ?? item.price;
      return total + (price * item.quantity);
    },
  );

  // -----------------------------------------------------------------------------
  // 🔹 Clear Entire Cart
  // -----------------------------------------------------------------------------
  Future<void> clearCart() async {
    await _cartBox.clear();
    cartItems.clear();
    CustomSnackBar(isSuccess: true, msg: "Cart cleared").showSnackBar();
  }
}
