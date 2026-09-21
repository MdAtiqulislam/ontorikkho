import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/privacy/models/privacy_policy_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

class PrivacyController extends GetxController {
  var isLoading=false.obs;

  var data ="".obs;

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

  void fetchData() async{
    isLoading.value=true;
    var endpoint=APIEndPoints.privacyPolicy;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);
      if(rs!=null){
        PrivacyPolicyModel privacyPolicyModel=PrivacyPolicyModel.fromJson(rs);
        data.value=privacyPolicyModel.data?.html??"";
      }
    } finally {
      isLoading.value=false;
    }
  }
}
