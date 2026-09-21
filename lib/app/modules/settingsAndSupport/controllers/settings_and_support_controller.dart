import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/services/local_services.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../../ownProfile/controllers/own_profile_controller.dart';

class SettingsAndSupportController extends GetxController {
  var isLoading=false.obs;

  var isTwoFaEnabled = false.obs;
  var userData=UserData().obs;


  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await getUserDat();
  }

  /// Toggle TwoFA
  void toggleTwoFA(bool value) {
    if (value) {
      Get.offAllNamed(Routes.TWO_STEP_VERIFICATION);
    }else{
      update2faStatus();
    }
  }

  Future<void> getUserDat() async {
    userData.value=await LocalServices.getUserData()??UserData();
    isTwoFaEnabled.value=userData.value.is2faStatusCheck.toString()=="1";
  }

  Future<void> _getData() async{
    isLoading.value=true;
    var endpoint=APIEndPoints.getUserData;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);
      if(rs!=null){
        UserDataModel user=UserDataModel.fromJson(rs);
        LocalServices.storeUserData(user.data??UserData());
       // Get.put(UserPersonalDataController()).user.value=user;
        Get.put(OwnProfileController()).getUserData();
        Get.put(HomeController()).getUserData();
        getUserDat();
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> update2faStatus()async {
    isLoading.value=true;
    var endpoint=APIEndPoints.twoFaStatusUpdate;
    var body={
      "is_2fa_status":"0"
    };
    var res=await RemoteServices.postRequest(endpoint: endpoint,body: body);
    if(res!=null){
      await LocalServices.store2FaCompletedStatus(false);
      _getData();
      CustomSnackBar(
        msg: res["msg"],
        isSuccess: true,
      ).showSnackBar();
    }else{
      CustomSnackBar(
        msg:APIEndPoints.httpErrorMSG.value,
        isSuccess: false,
      ).showSnackBar();
    }
  }
}
