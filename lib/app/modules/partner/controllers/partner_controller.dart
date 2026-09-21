import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/partner/models/partners_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';

class PartnerController extends GetxController with ScrollLoadMoreMixin {
  var isLoading = false.obs;
  var isLoadingMore=false.obs;
  var partners = <SinglePartner>[].obs;
  var pagination = Pagination().obs;
  final ScrollController scrollController=ScrollController();

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
    //  nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {
        final url = pagination.value.nextPageUrl;
        if (url != null) {
          loadMore(url: url);
        }
      },
    );
  }

  void _fetchData() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.partners;
    try {
      var rs = await RemoteServices.getRequest(endpoint: endpoint);
      if (rs != null) {
        PartnersModel partnersModel = PartnersModel.fromJson(rs);
        partners.value = partnersModel.data ?? [];
        pagination.value = partnersModel.pagination ?? Pagination();
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> loadMore({required String url}) async {
    isLoadingMore.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);
      if (rs != null) {
        PartnersModel partnersModel = PartnersModel.fromJson(rs);
        pagination.value = partnersModel.pagination ?? Pagination();
        partners.addAll(partnersModel.data??[]);

      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMore.value = false;
    }
  }

}
