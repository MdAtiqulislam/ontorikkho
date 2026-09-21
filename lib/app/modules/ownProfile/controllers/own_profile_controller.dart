import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/services/local_services.dart';

class OwnProfileController extends GetxController {

  var isLoading=false.obs;
  var user=UserData().obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }



  void getUserData()async {
    isLoading.value=true;
    await LocalServices.getUserData().then((value){
      user.value=value??UserData();
      isLoading.value=false;
    });
  }

}
