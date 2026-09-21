import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pages/models/search_page_model.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../models/pagination_model.dart';
import '../../../../services/remote_services.dart';
import '../../../../utils/enums.dart';
import '../models/page_data_model.dart';
import '../models/page_model.dart';

class SearchPageController extends GetxController {
  /// 🔍 Search Inputs
  RxString query = ''.obs;
  RxString name = ''.obs;
  RxString area = ''.obs;
  RxString school = ''.obs;
  RxString occupation = ''.obs;
  RxInt serviceId = 0.obs;

  /// 📋 Results
  RxList<PageModel> pagesList = <PageModel>[].obs;
  var pagination = Pagination().obs;

  /// ⏳ States
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isEmpty = false.obs;

  /// 📄 Pagination
  int currentPage = 1;
  int perPage = 10;
  bool hasMore = true;

  Worker? _debounce;

  @override
  void onInit() {
    super.onInit();

    _debounce = debounce(
      query,
          (_) => _onSearchTrigger(),
      time: const Duration(milliseconds: 500),
    );
  }

  void onQueryChanged(String value) {
    query.value = value;
  }

  void applyFilters({
    String? nameVal,
    String? areaVal,
    String? schoolVal,
    String? occupationVal,
    int? serviceIdVal,
  }) {
    name.value = nameVal ?? '';
    area.value = areaVal ?? '';
    school.value = schoolVal ?? '';
    occupation.value = occupationVal ?? '';
    serviceId.value = serviceIdVal ?? 0;

    _onSearchTrigger();
  }

  void _onSearchTrigger() {
    if (_hasAnyFilter()) {
      searchPage(isRefresh: true);
    } else {
      clearSearch();
    }
  }

  bool _hasAnyFilter() {
    return query.value.isNotEmpty ||
        name.value.isNotEmpty ||
        area.value.isNotEmpty ||
        school.value.isNotEmpty ||
        occupation.value.isNotEmpty ||
        serviceId.value > 0;
  }

  /// 📡 GET API
  Future<void> searchPage({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      pagesList.clear();
      isLoading.value = true;
    } else {
      if (!hasMore) return;
      isLoadingMore.value = true;
    }

    try {
      final params = {
        if (query.value.isNotEmpty) "query": query.value,
        if (name.value.isNotEmpty) "name": name.value,
        if (area.value.isNotEmpty) "area": area.value,
        if (school.value.isNotEmpty) "school": school.value,
        if (occupation.value.isNotEmpty) "occupation": occupation.value,
        if (serviceId.value > 0) "service_id": serviceId.value.toString(),
        "page": currentPage.toString(),
        "per_page": perPage.toString(),
      };

      final response = await RemoteServices.getRequest(
        endpoint: APIEndPoints.searchPage,
        parameters: params,
      );

      if (response == null) {
        isEmpty.value = true;
        return;
      }

      final searchResult = SearchPageModel.fromJson(response);

      final newItems = searchResult.data?.pages ?? [];

      if (isRefresh) {
        pagesList.assignAll(newItems);
      } else {
        pagesList.addAll(newItems);
      }

      pagination.value = searchResult.data?.pagination ?? Pagination();
      isEmpty.value = pagesList.isEmpty;

    } catch (e) {
      print("Search Error: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && hasMore) {
      currentPage++;
      searchPage();
    }
  }

  Future<void> refreshSearch() async {
    if (_hasAnyFilter()) {
      await searchPage(isRefresh: true);
    }
  }

  void clearSearch() {
    pagesList.clear();
    isEmpty.value = false;
    currentPage = 1;
    hasMore = true;
  }

  @override
  void onClose() {
    _debounce?.dispose();
    super.onClose();
  }

  /// =========================
  /// ACTION HANDLER
  /// =========================

  Future<void> handelPageAction({
    required PageActionType action,
    required String pageId,
  }) async
  {
    switch (action) {
      case PageActionType.follow:
        await _followPage(pageId);
        break;

      case PageActionType.unfollow:
        await _unfollowPage(pageId);
        break;

      case PageActionType.remove:
        await _removePageFromFollow(pageId);
        break;

      case PageActionType.accept:
        await _acceptPageInvitation(pageId);
        break;

      case PageActionType.denied:
        await _deniedPageInvitation(pageId);
        break;

      case PageActionType.block:
        await _blockPage(pageId);
        break;

      case PageActionType.unblock:
        await _unblockPage(pageId);
        break;

      default:
        break;
    }
  }

  /// =========================
  /// UPDATE HELPERS
  /// =========================

  void _updatePage(String pageId, PageDataModel updated) {
    final index = pagesList.indexWhere(
          (e) => e.page?.id.toString() == pageId,
    );

    if (index == -1) return;

    pagesList[index] = pagesList[index].copyWith(page: updated);
    pagesList.refresh();
  }

  /// =========================
  /// FOLLOW
  /// =========================

  Future<void> _followPage(String pageId) async {
    await _handleLoading(
      loader: isUpdating,
      request: () async {
        final res = await RemoteServices.postRequest(
          endpoint: APIEndPoints.markAsFollow,
          body: {"page_id": pageId},
        );

        if (res == null) return null;

        final data = res['data'];

        _updatePage(
          pageId,
          pagesList
              .firstWhere((e) => e.page?.id.toString() == pageId)
              .page!
              .copyWith(
            isFollowing: data['following'] ?? true,
            followersCount: data['followers_count'],
            pageStatus: data['following'] == true
                ? "following"
                : "notFollowing",
          ),
        );

        return null;
      },
    );
  }

  Future<void> _unfollowPage(String pageId) async {
    await _handleLoading(
      loader: isUpdating,
      request: () async {
        await RemoteServices.postRequest(
          endpoint: APIEndPoints.markAsUnfollow,
          body: {"page_id": pageId},
        );

        final page = pagesList
            .firstWhere((e) => e.page?.id.toString() == pageId)
            .page;

        if (page == null) return null;

        _updatePage(
          pageId,
          page.copyWith(
            isFollowing: false,
            pageStatus: "notFollowing",
          ),
        );

        return null;
      },
    );
  }

  /// =========================
  /// REMOVE / BLOCK ETC
  /// =========================

  Future<void> _removePageFromFollow(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.removePageFromFollow,
      body: {"page_id": pageId},
    );

    pagesList.removeWhere((e) => e.page?.id.toString() == pageId);
  }

  Future<void> _blockPage(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.blockPage,
      body: {"page_id": pageId},
    );

    final page = pagesList
        .firstWhere((e) => e.page?.id.toString() == pageId)
        .page;

    if (page == null) return;

    _updatePage(pageId, page.copyWith(isBlocked: true));
  }

  Future<void> _unblockPage(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.unblockPage,
      body: {"page_id": pageId},
    );

    final page = pagesList
        .firstWhere((e) => e.page?.id.toString() == pageId)
        .page;

    if (page == null) return;

    _updatePage(pageId, page.copyWith(isBlocked: false));
  }

  Future<void> _acceptPageInvitation(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.acceptPageInvitation,
      body: {"invitation_id": pageId},
    );
  }

  Future<void> _deniedPageInvitation(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.deniedPageInvitation,
      body: {"invitation_id": pageId},
    );

    pagesList.removeWhere((e) => e.page?.id.toString() == pageId);
  }

  /// =========================
  /// LOADER WRAPPER
  /// =========================

  Future<T?> _handleLoading<T>({
    required RxBool loader,
    required Future<T?> Function() request,
  }) async {
    loader.value = true;
    try {
      return await request();
    } finally {
      loader.value = false;
    }
  }
}