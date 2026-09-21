import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/referenceMemberList/models/reference_member_list_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

class ReferenceMemberListController extends GetxController {
  var isLoading = false.obs;
  var searchKey = "".obs;
  var referenceMemberListModel = ReferenceMemberListModel().obs;
  var memberList = <SingleReferenceMember>[].obs;

  @override
  void onInit() {
    super.onInit();

    // 🔃 Load initial data
    _getReferenceMemberList();

    // ⏳ Debounce logic - call API 3s after typing stops
    debounce(searchKey, (value) {
      _getReferenceMemberList();
    }, time: const Duration(seconds: 1));
  }

  // 🧠 API Call Function
  void _getReferenceMemberList() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getReferenceMemberList;
    var parameter = {"name": searchKey.value};

    try {
      var response = await RemoteServices.getRequest(
        endpoint: endpoint,
        parameters: parameter,
      );

      if (response != null) {
        referenceMemberListModel.value =
            ReferenceMemberListModel.fromJson(response);
        memberList.value = referenceMemberListModel.value.data ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 🔍 Only update the searchKey, debounce will handle the rest
  void search(String value) {
    searchKey.value = value;
  }
}
