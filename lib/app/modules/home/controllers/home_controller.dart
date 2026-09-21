
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/home/models/home_data_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../eventDetails/controllers/event_details_controller.dart';
import '../../events/models/event_list_model.dart';
import '../../missingDocuments/models/missing_documents_model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var loggedInUserModel = UserData().obs;
  var homeData = HomeDataModel().obs;

  var missingDocuments = <SingleMissingDocument>[].obs;

  var missingDocumentList = <SingleMissingDocument>[].obs;
  var pendingDocumentList = <SingleMissingDocument>[].obs;

  var missingDocumentCount = 0.obs;
  var pendingDocumentCount = 0.obs;

  @override
  Future<void> onInit() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    await Future.wait([
      getUserData(),
      _getHomeData(),
      getMissingDocuments(),
    ]);

    super.onInit();
  }

  Future<void> refreshHome() async {
    await Future.wait([
      _fetchUserData().then((value){
        getUserData();
        _getHomeData(isLoadingNew: false);
        getMissingDocuments();
      })

    ]);
  }

  Future<void> _fetchUserData() async {
    isLoading.value = true;
    try {
      final res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        UserDataModel  userDataModel = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(userDataModel.data ?? UserData());
      }
    } catch (e) {
      if (kDebugMode) print("Fetch user data error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserData() async {
    try {
      loggedInUserModel.value = await LocalServices.getUserData() ?? UserData();
    } finally {}
  }

  Future<void> _getHomeData({bool isLoadingNew = true}) async {
    isLoadingNew ? isLoading.value = true : isUpdating.value = true;
    var endpoint = APIEndPoints.homeData;

    try {
      var rs = await RemoteServices.getRequest(endpoint: endpoint);
      if (rs != null) {
        homeData.value = HomeDataModel.fromJson(rs);
      }
    } finally {
      isLoadingNew ? isLoading.value = false : isUpdating.value = false;
    }
  }

  Future<void> pendingUserApproval({required String id}) async {
    isUpdating.value = true;

    var endpoint = APIEndPoints.pendingUserApproval;
    var parameters = {"id": id};

    try {
      var rs = await RemoteServices.postRequest(endpoint: endpoint, parameters: parameters);

      if (rs != null) {
        CustomSnackBar(isSuccess: true, msg: rs["msg"]).showSnackBar();
        _getHomeData(isLoadingNew: false);
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void getEventDetails({required SingleEvent event}) {
    Get.put(EventDetailsController()).getDetails(id: event.id.toString());
    Get.toNamed(Routes.EVENT_DETAILS);
  }

  Future<void> getMissingDocuments() async {
    var endpoint = APIEndPoints.getMissingDocuments;

    try {
      var res = await RemoteServices.getRequest(endpoint: endpoint);

      if (res != null) {
        MissingDocumentsModel missingDocsModel = MissingDocumentsModel.fromJson(res);
        missingDocuments.value = missingDocsModel.data ?? [];

        missingDocumentList.value =
            missingDocuments.where((doc) => doc.documentMediaId == null).toList();
        missingDocumentCount.value = missingDocumentList.length;

        pendingDocumentList.value = missingDocuments
            .where((doc) =>
        doc.documentMediaId != null &&
            (doc.adminStatus?.toLowerCase() == "pending"))
            .toList();
        pendingDocumentCount.value = pendingDocumentList.length;
      }
    } finally {}
  }
}
