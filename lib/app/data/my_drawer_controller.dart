
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/local_services.dart';
import '../modules/login/controllers/login_controller.dart';
import '../routes/app_pages.dart';

class MyDrawerController extends GetxController {
  var isLoading=false.obs;
  var userData=UserModel().obs;

  void logOut() async {
    isLoading.value = true;
    // var endPoint = APIEndPoints.logOut;
    try {
      /* var response = await RemoteServices.postRequest(endPoint: endPoint);
      if (response != null) {

      }*/
    } finally {
      // await LocalServices.deleteData();
      await LocalServices.deleteDataBasedOnRememberMe();

      Get.offAllNamed(Routes.LOGIN);
     // Get.put(LoginController()).loadEmailAndPassword();
      isLoading.value = false;
    }
  }

  Future<void> getUserData() async{
    userData.value=await LocalServices.getUser()??UserModel();
    print(userData.value.name);
  }

}
