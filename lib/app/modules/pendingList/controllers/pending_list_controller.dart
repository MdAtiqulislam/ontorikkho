import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pendingList/models/pending_list_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/models/single_pending_item.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';

class PendingListController extends GetxController with ScrollLoadMoreMixin{

  var isLoading=false.obs;
  var isLoadingMore=false.obs;
  var isUpdating=false.obs;

  var pendingList=<SinglePendingItem>[].obs;
  var pagination=Pagination().obs;

  ScrollController loadMoreScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: loadMoreScrollController,
      isLoadingMore: isLoadingMore,
     // nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {
        final url = pagination.value.nextPageUrl;
        if (url != null) {
          loadMore(url: url);
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchData({bool isLoadingNew=true})async {
    isLoadingNew?isLoading.value=true:isUpdating.value=true;
    var endpoint=APIEndPoints.pendingList;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);
      if(rs!=null){
        PendingListModel pendingListModel=PendingListModel.fromJson(rs);
        pagination.value=pendingListModel.pagination??Pagination();
        pendingList.value=pendingListModel.data??[];
      }
    } finally {
      isLoadingNew?isLoading.value=false:isUpdating.value=false;
    }
  }

  Future<void> loadMore({required String url}) async {
    isLoadingMore.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);
      if (rs != null) {
        PendingListModel pendingListModel = PendingListModel.fromJson(rs);
        pagination.value = pendingListModel.pagination ?? Pagination();
        pendingList.addAll(pendingListModel.data??[]);

      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void>pendingUserApproval({required String id})async{
    isUpdating.value=true;
    var endpoint=APIEndPoints.pendingUserApproval;
    var parameters={"id":id};
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint,parameters: parameters);
      if(rs!=null){
        CustomSnackBar(
          isSuccess: true,
          msg: rs["msg"]
        ).showSnackBar();
        fetchData(isLoadingNew: false);
      }else{
        CustomSnackBar(
            isSuccess: false,
            msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isUpdating.value=false;
    }
  }

}
