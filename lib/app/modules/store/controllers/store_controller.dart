import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/cart/controllers/cart_controller.dart';
import 'package:ontorikkho/app/modules/cart/models/cart_item_model.dart';
import 'package:ontorikkho/app/modules/store/models/order_history_model.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/utils/mixins.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../models/single_product.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../productDetails/models/product_details_model.dart';
import '../models/product_list_model.dart';

class StoreController extends GetxController with ScrollLoadMoreMixin {
  var isLoadingProduct = false.obs;
  var isLoadingMoreProduct = false.obs;

  var isUpdatingProduct = false.obs;

  var isLoadingHistory = false.obs;
  var isLoadingMoreHistory = false.obs;

  var selectedTab = 0.obs;
  var pagination = Pagination().obs;
  var products = <SingleProduct>[].obs;

  var orderHistory = <SingleOrderHistory>[].obs;
  var favouriteProducts = <SingleProduct>[].obs;

  var productDetails = ProductDetailsModel().obs;

  // Reactive color group
  var colorGroup = <ColorGroup>[].obs;

  ScrollController trackScrollController = ScrollController();
  ScrollController historyScrollController = ScrollController();

  var selectedColorGroupIndex=0.obs;

  var selectedSizeIndex=0.obs;

  var quantity=1.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchProduct();
    _fetchOrderHistory();
    getFavouriteProducts();
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: trackScrollController,
      isLoadingMore: isLoadingMoreProduct,
     // nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {
        final url = pagination.value.nextPageUrl;
        if (url != null) {
          loadMore(url: url);
        }
      },
    );

    // need to modify
    setupLoadMore(
      controller: historyScrollController,
      isLoadingMore: isLoadingMoreHistory,
     // nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {
        final url = pagination.value.nextPageUrl;
        if (url != null) {
          loadMore(url: url);
        }
      },
    );
  }

  void _fetchProduct() async {
    isLoadingProduct.value = true;
    var endpoint = APIEndPoints.products;
    try {
      var rs = await RemoteServices.getRequest(endpoint: endpoint);
      if (rs != null) {
        ProductListModel productListModel = ProductListModel.fromJson(rs);
        products.value = productListModel.data?.data ?? [];
        pagination.value = productListModel.pagination ?? Pagination();
      }
    } finally {
      isLoadingProduct.value = false;
    }
  }

  void _fetchOrderHistory() async {
    isLoadingHistory.value = true;
    var endpoint = APIEndPoints.orderHistory;
    try {
      var rs = await RemoteServices.getRequest(endpoint: endpoint);
      if (rs != null) {
        OrderHistoryModel orderHistoryModel = OrderHistoryModel.fromJson(rs);
        orderHistory.value = orderHistoryModel.data ?? [];
        //pagination.value = productListModel.pagination ?? PaginationModel();
      }
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> loadMore({required String url}) async {
    isLoadingMoreProduct.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);
      if (rs != null) {
        ProductListModel productListModel = ProductListModel.fromJson(rs);
        pagination.value = productListModel.pagination ?? Pagination();
        products.addAll(productListModel.data?.data ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMoreProduct.value = false;
    }
  }

  Future<void> getFavouriteProducts() async {
    favouriteProducts.value = await LocalServices.getFavouriteProducts();
  }

  Future<void> addOrUpdateFavouriteProduct({
    required SingleProduct product,
  }) async {
    await LocalServices.addOrUpdateFavouriteProduct(product);
    await getFavouriteProducts();
    refresh();
  }

  void addToCart({
    required String productId,
    required String title,
    required String imageUrl,
    required double price,
    required String availableQty,
    int quantity = 1,
    double? discountPrice,
    String? afterDiscountPrice,
    String? size,
    String? color,}) {
    final cartController = Get.put(CartController());

    cartController.addToCart(
      productId: productId,
      title: title,
      imageUrl: imageUrl,
      price: price,
      discountPrice:discountPrice,
      afterDiscountPrice: afterDiscountPrice,
      quantity: quantity,
      size: size,
      color: color,
      availableQuantity: availableQty,
    );
  }

  Future<void> getDetails({required String id}) async {
    isUpdatingProduct.value = true;
    colorGroup.value=[];
    quantity.value=1;
    selectedColorGroupIndex.value=0;
    selectedSizeIndex.value=0;
    var endpoint = APIEndPoints.productDetails;
    var parameters = {"id": id};
    try {
      var rs = await RemoteServices.getRequest(
        endpoint: endpoint,
        parameters: parameters,
      );
      if (rs != null) {
        productDetails.value = ProductDetailsModel.fromJson(rs);
        colorGroup.value = productDetails.value.data?.productDetails ?? [];
      }
    } finally {
      isUpdatingProduct.value = false;
    }
  }
}
