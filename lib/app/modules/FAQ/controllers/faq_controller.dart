import 'package:get/get.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

import '../models/faq_model.dart';

class FaqController extends GetxController {

  var isLoading = false.obs;
  var expandedIndex = (-1).obs; // -1 means no item is expanded
  var expandedIndices = <bool>[].obs;

  final faqs=<SingleFAQ>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchData();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void toggleExpansion(int index) {
    expandedIndices[index] = !expandedIndices[index];
    expandedIndices.refresh(); // Force GetX to rebuild UI
  }

  void fetchData()async {
    isLoading.value=true;
    var endpoint=APIEndPoints.faq;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);
      if(rs!=null){
        FaqModel faqModel=FaqModel.fromJson(rs);
        faqs.value=faqModel.data??[];
        expandedIndices.value = List.generate(faqs.length, (index) => false);
      }
    } finally {
      isLoading.value=false;
    }
  }
}
