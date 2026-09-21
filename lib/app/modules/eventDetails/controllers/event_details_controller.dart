import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/eventDetails/models/event_details_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

import '../../../../common_widgets/custom_snackbar.dart';

class EventDetailsController extends GetxController {

  var isLoading=false.obs;
  var eventDetails=EventDetailsModel().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  void getDetails({required String id}) async{
    isLoading.value=true;
    var endpoint=APIEndPoints.eventDetails;
    var body={"id":id};
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint,parameters: body);
      if(rs!=null){
        eventDetails.value=EventDetailsModel.fromJson(rs);
      }
    } finally {
      isLoading.value=false;
    }
  }

  void joinEvent()async {
    //isLoadin.value=true;
    var body={"event_id":eventDetails.value.data?.id.toString()};
    var endpoint=APIEndPoints.joinEvent;
    try {
      var rs=await RemoteServices.postRequest(endpoint: endpoint,body: body);
      if(rs!=null){
        CustomSnackBar(
            isSuccess: true,
            msg: rs["msg"]
        ).showSnackBar();
      }else{
        CustomSnackBar(
            isSuccess: false,
            msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }
  }
}
