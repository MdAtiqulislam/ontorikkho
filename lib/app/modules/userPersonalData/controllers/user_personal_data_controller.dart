import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

class UserPersonalDataController extends GetxController {


  var user=UserDataModel().obs;
  var isLoading=false.obs;

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

  void getData() async{
    isLoading.value=true;
    var endpoint=APIEndPoints.getUserData;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);
      if(rs!=null){
        user.value=UserDataModel.fromJson(rs);
      }
    } finally {
      isLoading.value=false;
    }
  }


}
