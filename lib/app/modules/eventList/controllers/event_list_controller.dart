import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/events/models/event_list_model.dart';
import '../../../../models/pagination_model.dart';
import 'package:ontorikkho/utils/mixins.dart';

import '../../../../services/remote_services.dart';

class EventListController extends GetxController with ScrollLoadMoreMixin {

  var isLoading=false.obs;
  var isLoadingMore=false.obs;
  var eventList=<SingleEvent>[].obs;
  var paginationModel = Pagination().obs;
  var type="".obs;//Upcoming Events and Ongoing Events


  final ScrollController scrollController=ScrollController();


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
     // nextPageUrl: paginationModel.value.nextPageUrl,
      onLoadMore: () {
        final url = paginationModel.value.nextPageUrl;
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


  Future<void> loadMore({required String url}) async {
    isLoadingMore.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);

      if (rs != null) {
       //TODO
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
