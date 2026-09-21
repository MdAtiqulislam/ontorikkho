import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/productDetails/models/product_details_model.dart';
import 'package:ontorikkho/app/modules/store/controllers/store_controller.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

import '../../../../models/single_product.dart';
import '../../../../services/local_services.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  var isLoading = false.obs;

  var productDetails = ProductDetailsModel().obs;
  var favouriteProducts = <SingleProduct>[].obs;

  // Reactive color group
  var colorGroup = <ColorGroup>[].obs;

  var isUpdating = false.obs;

  // Selected indices
  var selectedColorGroupIndex = 0.obs;
  var selectedSizeIndex = 0.obs;

  var quantity = 1.obs;

  var isFav = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch product details
  void fetchData({required String id}) async {
    isLoading.value = true;
    var endpoint = APIEndPoints.productDetails;
    var parameters = {"id": id};

    try {
      var rs = await RemoteServices.getRequest(
        endpoint: endpoint,
        parameters: parameters,
      );
      if (rs != null) {
        productDetails.value = ProductDetailsModel.fromJson(rs);

        // Ensure colorGroup is reactive
        colorGroup.value = productDetails.value.data?.productDetails ?? [];
        _getFavouriteProducts();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a color
  void selectColor(int index) {
    selectedColorGroupIndex.value = index;
    selectedSizeIndex.value = 0; // reset size selection
  }

  /// Select a size
  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  /// Get currently selected sizes
  List<Size> get selectedSizes =>
      colorGroup.isNotEmpty
          ? colorGroup[selectedColorGroupIndex.value].sizes ?? []
          : [];

  void addToCart() {
    final cartController = Get.put(CartController());

    cartController.addToCart(
      quantity: quantity.value,
      productId: (productDetails.value.data?.id ?? "0").toString(),
      title: (productDetails.value.data?.name ?? "").toString(),
      imageUrl: (productDetails.value.data?.productImage ?? "").toString(),
      price:
          double.tryParse(
            (productDetails.value.data?.price ?? "0").toString(),
          ) ??
          0,
      discountPrice: double.tryParse(
        (productDetails.value.data?.discountPrice ?? "0").toString(),
      ),
      afterDiscountPrice:
          (productDetails.value.data?.afterDiscountPrice ?? "0").toString(),
      size: selectedSizes[selectedSizeIndex.value].sizeName,
      color: colorGroup[selectedColorGroupIndex.value].colorName,
      availableQuantity: selectedSizes[selectedSizeIndex.value].qty??"0",
    );
  }

  Future<void> _getFavouriteProducts() async {
    favouriteProducts.value = await LocalServices.getFavouriteProducts();
    isFav.value = favouriteProducts.any(
      (e) => e.id == productDetails.value.data?.id,
    );
  }

  Future<void> addOrUpdateFavouriteProduct({
    required SingleProduct product,
  }) async {
    await LocalServices.addOrUpdateFavouriteProduct(product);
    await _getFavouriteProducts();
    refresh();
    Get.put(StoreController()).getFavouriteProducts();
  }
}
