import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/services/local_services.dart';

class MembershipRenewController extends GetxController {


  var autoRenewal=true.obs;

  var user=UserData().obs;

  var isLoadin=false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await getUserData();

  }

  Future<void>getUserData()async{
    await await LocalServices.getUserData().then((value){
      user.value=value??UserData();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
