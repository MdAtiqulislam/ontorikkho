import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/directory/models/member_directory_model.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/utils/mixins.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';

class DirectoryController extends GetxController with ScrollLoadMoreMixin{

  var isLoading=false.obs;
  var isLoadingMore=false.obs;
  var searchKey="".obs;

  var generalMembers=<SingleDirectory>[].obs;
  var boardMembers=<SingleDirectory>[].obs;
  var pagination=Pagination().obs;
  final ScrollController scrollController=ScrollController();


  var showSearchBar = false.obs;

  void toggleSearchBar() {
    showSearchBar.value = !showSearchBar.value;
  }

  void hideSearchBar() {
    showSearchBar.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _fetchData();
    debounce(searchKey, (value) {
      _fetchData();
    }, time: const Duration(seconds: 1));
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: scrollController,
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


  void _fetchData() async {
    isLoading.value = true;
    var parameters={"name":searchKey.value};
    var endpoint = APIEndPoints.memberDirectories;
    try {
      var rs = await RemoteServices.getRequest(endpoint: endpoint,parameters: parameters);
      if (rs != null) {
        MemberDirectoryModel memberDirectoryModel = MemberDirectoryModel.fromJson(rs);
        generalMembers.value = memberDirectoryModel.data ?? [];
        boardMembers.value = memberDirectoryModel.boardMembers ?? [];
        pagination.value = memberDirectoryModel.pagination ?? Pagination();
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
        MemberDirectoryModel memberDirectoryModel = MemberDirectoryModel.fromJson(rs);
        pagination.value = memberDirectoryModel.pagination ?? Pagination();
        generalMembers.addAll(memberDirectoryModel.data??[]);

      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMore.value = false;
    }
  }

  void search(String value) {
    searchKey.value = value;
  }



  Future<void> openDialler({required String phone}) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
    } else {
    Get.snackbar('Error', 'Could not launch dialer');
    }

  }

}

