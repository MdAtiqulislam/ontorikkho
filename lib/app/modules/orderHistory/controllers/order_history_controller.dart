import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../store/models/order_history_model.dart';

class OrderHistoryController extends GetxController {
  var isLoadingHistory = false.obs;
  var isLoadingMoreHistory = false.obs;
  var orderHistory = <SingleOrderHistory>[].obs;

  ScrollController historyScrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  void fetchOrderHistory() async {
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

}
