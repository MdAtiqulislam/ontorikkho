import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/announcements/models/general_announcement_model.dart';
import 'package:ontorikkho/app/modules/announcements/models/urgent_announcement_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/models/single_announcement.dart';
import 'package:ontorikkho/utils/mixins.dart';
import '../../../../services/remote_services.dart';

class AnnouncementsController extends GetxController with ScrollLoadMoreMixin {
  // Loading flags
  final isLoadingGeneralData = false.obs;
  final isLoadingMoreGeneralData = false.obs;
  final isLoadingUrgentData = false.obs;
  final isLoadingMoreUrgentData = false.obs;

  // Pagination
  final generalAnnouncementPagination = Pagination().obs;
  final urgentAnnouncementPagination = Pagination().obs;

  // Data lists
  final generalAnnouncements = <SingleAnnouncement>[].obs;
  final urgentAnnouncements = <SingleAnnouncement>[].obs;

  // Scroll controllers
  final generalAnnouncementScrollController = ScrollController();
  final urgentAnnouncementScrollController = ScrollController();

  // Tab selector
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchGeneral();
    _fetchUrgent();
  }

  @override
  void onReady() {
    super.onReady();

    // Setup general announcements scroll load more
    setupLoadMore(
      controller: generalAnnouncementScrollController,
      isLoadingMore: isLoadingMoreGeneralData,
     // nextPageUrl: generalAnnouncementPagination.value.nextPageUrl,
      onLoadMore: () {
        final url = generalAnnouncementPagination.value.nextPageUrl;
        if (url != null) loadMoreGeneralData(url: url);
      },
    );

    // Setup urgent announcements scroll load more
    setupLoadMore(
      controller: urgentAnnouncementScrollController,
      isLoadingMore: isLoadingMoreUrgentData,
      //nextPageUrl: urgentAnnouncementPagination.value.nextPageUrl,
      onLoadMore: () {
        final url = urgentAnnouncementPagination.value.nextPageUrl;
        if (url != null) loadMoreUrgentData(url: url);
      },
    );
  }

  @override
  void onClose() {
    generalAnnouncementScrollController.dispose();
    urgentAnnouncementScrollController.dispose();
    super.onClose();
  }

  // Generic Load More
  Future<void> _loadMoreAnnouncements<T>({
    required String url,
    required RxBool isLoading,
    required T Function(dynamic json) fromJson,
    required Rx<Pagination> pagination,
    required RxList<SingleAnnouncement> targetList,
  }) async {
    isLoading.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);
      if (rs != null) {
        final model = fromJson(rs);
        if (model is GeneralAnnouncementModel || model is UrgentAnnouncementModel) {
          pagination.value = (model as dynamic).pagination ?? Pagination();
          targetList.addAll((model as dynamic).data ?? []);
        }
      }
    } catch (e) {
      if (kDebugMode) print('LoadMore error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreGeneralData({required String url}) async {
    await _loadMoreAnnouncements<GeneralAnnouncementModel>(
      url: url,
      isLoading: isLoadingMoreGeneralData,
      fromJson: (json) => GeneralAnnouncementModel.fromJson(json),
      pagination: generalAnnouncementPagination,
      targetList: generalAnnouncements,
    );
  }

  Future<void> loadMoreUrgentData({required String url}) async {
    await _loadMoreAnnouncements<UrgentAnnouncementModel>(
      url: url,
      isLoading: isLoadingMoreUrgentData,
      fromJson: (json) => UrgentAnnouncementModel.fromJson(json),
      pagination: urgentAnnouncementPagination,
      targetList: urgentAnnouncements,
    );
  }

  Future<void> _fetchGeneral() async {
    isLoadingGeneralData.value = true;
    try {
      final rs = await RemoteServices.getRequest(endpoint: APIEndPoints.generalAnnouncements);
      if (rs != null) {
        final model = GeneralAnnouncementModel.fromJson(rs);
        generalAnnouncements.value = model.data ?? [];
        generalAnnouncementPagination.value = model.pagination ?? Pagination();
      }
    } finally {
      isLoadingGeneralData.value = false;
    }
  }

  Future<void> _fetchUrgent() async {
    isLoadingUrgentData.value = true;
    try {
      final rs = await RemoteServices.getRequest(endpoint: APIEndPoints.urgentAnnouncements);
      if (rs != null) {
        final model = UrgentAnnouncementModel.fromJson(rs);
        urgentAnnouncements.value = model.data ?? [];
        urgentAnnouncementPagination.value = model.pagination ?? Pagination();
      }
    } finally {
      isLoadingUrgentData.value = false;
    }
  }
}
