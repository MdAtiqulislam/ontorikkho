import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/orderDetails/models/order_details_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

class OrderDetailsController extends GetxController {
  var isLoading = false.obs;

  var order=OrderDetailsModel().obs;

  @override
  void onInit() {
    super.onInit();
    final orderId = Get.arguments?["orderId"];
    if (orderId != null) {
      getOrderDetails(orderId: orderId);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

Future<void>getOrderDetails({required String orderId})async{
    isLoading.value=true;
    var endpoint=APIEndPoints.getOrderDetails;
    var parameters={"id":orderId};
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint,parameters: parameters);
      if(res!=null){
        order.value=OrderDetailsModel.fromJson(res);
      }
    } finally {
      isLoading.value=false;
    }
}
}
