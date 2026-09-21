import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/support/models/support_data_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportController extends GetxController {


  var isLoading=false.obs;
  var supportData=SupportData().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getSupportData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void>getSupportData()async{
    isLoading.value=true;
    var endpoint=APIEndPoints.getSupport;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
        SupportDataModel supportDataModel=SupportDataModel.fromJson(res);
        supportData.value=supportDataModel.data??SupportData();
      }
    } finally {
      isLoading.value=false;
    }
  }


  Future<void> launchPhone(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("Error", "Cannot launch phone dialer.");
    }
  }

  Future<void> launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=Hello&body=Hi,'),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar("Error", "No email app found on this device.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to open email app: $e");
    }
  }



}
