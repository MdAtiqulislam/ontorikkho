import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/models/search_friend_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import '../../../../models/pagination_model.dart';
import '../../../../services/remote_services.dart';
import '../../../../utils/enums.dart';

class FriendSearchController extends GetxController {

  /// 🔍 Search Inputs
  RxString query = ''.obs;
  RxString name = ''.obs;
  RxString area = ''.obs;
  RxString school = ''.obs;
  RxString occupation = ''.obs;
  RxInt? serviceId = RxInt(0);

  /// 📋 Results
  RxList<SearchUser> results = <SearchUser>[].obs;
  var pagination= Pagination().obs;


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

    /// 🔥 debounce only for query
    _debounce = debounce(
      query,
          (_) => _onSearchTrigger(),
      time: Duration(milliseconds: 500),
    );
  }

  /// 🔍 search field change
  void onQueryChanged(String value) {
    query.value = value;
  }

  /// 🎯 apply filter (manual trigger)
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
    serviceId?.value = serviceIdVal ?? 0;

    _onSearchTrigger();
  }

  /// 🚀 central trigger
  void _onSearchTrigger() {
    if (_hasAnyFilter()) {
      searchFriends(isRefresh: true);
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
        (serviceId?.value ?? 0) > 0;
  }

  /// 📡 GET API Call
  Future<void> searchFriends({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      results.clear();
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
        if ((serviceId?.value ?? 0) > 0) "service_id": serviceId!.value.toString(),
        "page": currentPage.toString(),
        "per_page": perPage.toString(),
      };

      final response = await RemoteServices.getRequest(
        endpoint: APIEndPoints.searchFriends,
        parameters: params,
      );

      if (response != null) {
        SearchFriendModel searchResult = SearchFriendModel.fromJson(response);
        results.value= searchResult.data?.users ?? [];
        pagination.value = searchResult.data?.pagination ?? Pagination();

      } else {
        isEmpty.value = true;
      }
    } catch (e) {
      print("Search Error: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 📄 Pagination
  void loadMore() {
    if (!isLoadingMore.value && hasMore) {
      searchFriends();
    }
  }

  /// 🔄 Refresh
  Future<void> refreshSearch() async {
    if (_hasAnyFilter()) {
      await searchFriends(isRefresh: true);
    }
  }

  /// ❌ Clear
  void clearSearch() {
    results.clear();
    isEmpty.value = false;
    currentPage = 1;
    hasMore = true;
  }

  @override
  void onClose() {
    _debounce?.dispose();
    super.onClose();
  }

  void updateItemStatus({
    required int index,
    required FriendActionType action,
  })
  {
    final oldItem = results[index];
    final oldUser = oldItem.user;

    if (oldUser == null) return;

    String? newStatus;


    switch (action) {
      case FriendActionType.add:
        newStatus = "sent";
        break;

      case FriendActionType.cancel:
        newStatus = "";
        break;

      case FriendActionType.confirm:
        newStatus = "friend";
        break;

      case FriendActionType.delete:
        newStatus = "";
        break;

      case FriendActionType.unfriend:
        newStatus = "";
        break;
        case FriendActionType.block:
        newStatus = "blocked";
        break;
        case FriendActionType.unblock:
        newStatus = "friend";
        break;

      default:
        break;
    }

    /// ✅ update user
    final updatedUser = oldUser.copyWith(
      friendshipStatus: newStatus,
    );

    /// ✅ replace item
    results[index] = oldItem.copyWith(
      user: updatedUser,
      isFriend: newStatus == "friend",
    );

    results.refresh();
  }
}