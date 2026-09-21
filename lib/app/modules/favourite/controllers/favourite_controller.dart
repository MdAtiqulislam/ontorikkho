import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/events/models/event_list_model.dart';
import 'package:ontorikkho/services/local_services.dart';

import '../../../../models/single_product.dart';
import '../../../routes/app_pages.dart';
import '../../eventDetails/controllers/event_details_controller.dart';

class FavouriteController extends GetxController {
  var isLoading=false.obs;
  var isReloading=false.obs;

  var selectedTab=0.obs;


  var events=<SingleEvent>[].obs;
  var products=<SingleProduct>[].obs;


  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getData()async {
    isLoading.value=true;
    try {
      events.value=await LocalServices.getFavouriteEvents();
      products.value=await LocalServices.getFavouriteProducts();
    } finally {
     isLoading.value=false;
    }
  }

  Future<void> addOrUpdateFavouriteEvent({required SingleEvent event}) async{
    await LocalServices.addOrUpdateFavouriteEvent(event);
    await _reloadData();
    refresh();
  }

  Future<void> addOrUpdateFavouriteProduct({required SingleProduct product}) async{
    await LocalServices.addOrUpdateFavouriteProduct(product);
    await _reloadData();
    refresh();
  }

  void getDetails({required SingleEvent event}) {
    Get.put(EventDetailsController()).getDetails(id:event.id.toString());
    Get.toNamed(Routes.EVENT_DETAILS);
  }

  Future<void> _reloadData()async {
    isReloading.value=true;
    try {
      events.value=await LocalServices.getFavouriteEvents();
      products.value=await LocalServices.getFavouriteProducts();
    } finally {
      isReloading.value=false;
    }
  }

}
