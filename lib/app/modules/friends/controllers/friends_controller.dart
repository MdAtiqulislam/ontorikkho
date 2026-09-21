/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_request_incoming_model.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_suggestion_model.dart';
import 'package:ontorikkho/app/modules/friends/models/my_friends_model.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/views/incoming_friend_request_view.dart';
import 'package:ontorikkho/app/modules/friends/views/my_friends_view.dart';
import 'package:ontorikkho/app/modules/friends/views/sent_requests_view.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/utils/mixins.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../models/pagination_model.dart';
import '../../../../services/remote_services.dart';
import '../../../../utils/enums.dart';
import '../../../routes/app_pages.dart';
import '../../profileFeed/controllers/profile_feed_controller.dart';
import '../bindings/friends_binding.dart';
import '../models/single_friend_model.dart';
import '../views/friend_suggestions_view.dart';
import '../views/search_friends_view.dart';
import '../widgets/custom_user_action_sheet.dart';

class FriendsController extends GetxController with ScrollLoadMoreMixin {

  /// -----------------------------
  /// Loading States
  /// -----------------------------
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isLoadingMore = false.obs;

  var pagination = Pagination().obs;

  /// -----------------------------
  /// Data Lists
  /// -----------------------------
  var friendSuggestions = <SingleFriendModel>[].obs;
  var friendRequestIncoming = <SingleFriendModel>[].obs;
  var friendRequestSent = <SingleFriendModel>[].obs;
  var myFriends = <FriendsBasicInfoModel>[].obs;

  final ScrollController scrollController = ScrollController();

  /// -----------------------------
  /// 🔍 Search States
  /// -----------------------------
  RxString suggestionSearch = ''.obs;
  RxString incomingSearch = ''.obs;
  RxString sentSearch = ''.obs;
  RxString myFriendsSearch = ''.obs;

  /// -----------------------------
  /// ⚡ Debounce Workers
  /// -----------------------------
  Worker? _suggestionDebounce;
  Worker? _incomingDebounce;
  Worker? _sentDebounce;
  Worker? _friendsDebounce;

  /// -----------------------------
  /// Navigate
  /// -----------------------------
  void goToSearchPage() {
    Get.to(
          () => SearchFriendsView(),
      binding: FriendSearchBinding(),
    );
  }
  Future<void> changeView({required FriendFilterType type}) async {
    isLoading.value = true;

    switch (type) {
      case FriendFilterType.suggestions:
        Get.to(() => FriendSuggestionsView());
        await getFriendSuggestions();
        break;
      case FriendFilterType.sent:
        Get.to(() => PendingFriendRequestView());
        await getFriendRequestSent();
        break;
      case FriendFilterType.incoming:
        Get.to(() => IncomingFriendRequestView());
        await getFriendRequestIncoming();
        break;
      case FriendFilterType.yourFriends:
        Get.to(() => MyFriendsView());
        await getMyFriends();
        break;
    }
    isLoading.value = false;
  }
  /// -----------------------------
  /// Lifecycle
  /// -----------------------------
  @override
  void onInit() {
    super.onInit();

    _suggestionDebounce = debounce(
      suggestionSearch,
          (_) => getFriendSuggestions(),
      time: const Duration(milliseconds: 500),
    );

    _incomingDebounce = debounce(
      incomingSearch,
          (_) => getFriendRequestIncoming(),
      time: const Duration(milliseconds: 500),
    );

    _sentDebounce = debounce(
      sentSearch,
          (_) => getFriendRequestSent(),
      time: const Duration(milliseconds: 500),
    );

    _friendsDebounce = debounce(
      myFriendsSearch,
          (_) => getMyFriends(),
      time: const Duration(milliseconds: 500),
    );

    //initData();
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
      nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {},
    );
  }

  /// -----------------------------
  /// Refresh
  /// -----------------------------
  Future<void> refreshFriends() async {
    isUpdating.value = true;
    try {
      await Future.wait([
        getFriendSuggestions(),
        getFriendRequestIncoming(),
        getFriendRequestSent(),
        getMyFriends(),
      ]);
    } catch (e) {
      print("Refresh error: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> initData() async {
    isLoading.value = true;
    try {
      await refreshFriends();
    } finally {
      isLoading.value = false;
    }
  }

  /// -----------------------------
  /// API Calls
  /// -----------------------------
  Future<void> getFriendSuggestions() async {
    try {
      final response = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getFriendSuggestions,
        parameters: {
          if (suggestionSearch.value.isNotEmpty)
            "query": suggestionSearch.value,
        },
      );

      if (response != null) {
        final model = FriendSuggestionModel.fromJson(response);
        friendSuggestions.value = model.data?.suggestions ?? [];
      }
    } catch (e) {
      print("Suggestion error: $e");
    }
  }

  Future<void> getFriendRequestIncoming() async {
    try {
      final response = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getFriendRequestIncoming,
        parameters: {
          if (incomingSearch.value.isNotEmpty)
            "query": incomingSearch.value,
        },
      );

      if (response != null) {
        final model = FriendRequestIncomingModel.fromJson(response);
        friendRequestIncoming.value = model.data?.requests ?? [];
      }
    } catch (e) {
      print("Incoming error: $e");
    }
  }

  Future<void> getFriendRequestSent() async {
    try {
      final response = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getFriendRequestSent,
        parameters: {
          if (sentSearch.value.isNotEmpty)
            "query": sentSearch.value,
        },
      );

      if (response != null) {
        final model = FriendRequestIncomingModel.fromJson(response);
        friendRequestSent.value = model.data?.requests ?? [];
      }
    } catch (e) {
      print("Sent error: $e");
    }
  }

  Future<void> getMyFriends() async {
    try {
      final response = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getMyFriends,
        parameters: {
          if (myFriendsSearch.value.isNotEmpty)
            "query": myFriendsSearch.value,
        },
      );

      if (response != null) {
        MyFriendsModel model = MyFriendsModel.fromJson(response);
        myFriends.value = model.data?.friends ?? [];
      }
    } catch (e) {
      print("Friends error: $e");
    }
  }


  /// -----------------------------
  /// Search Handler
  /// -----------------------------
  void onSearchChanged({
    required RxString field,
    required String value,
  }) {
    field.value = value;
  }

  /// -----------------------------
  /// Friend Actions
  /// -----------------------------
  Future<FriendActionType?> handleFriendAction({
    required FriendActionType action,
    String? friendId,
    String? requestId,
    FriendsBasicInfoModel? friend,
  }) async {

    switch (action) {

      case FriendActionType.openMenu:
        return await _openFriendMenu(friend: friend!);

      case FriendActionType.unfriend:
        if (friendId != null && await onUnfriend(friendId: friendId)) {
          return FriendActionType.unfriend;
        }
        break;

      case FriendActionType.block:
        if (friendId != null && await onBlockUser(friendId: friendId)) {
          _updateBlockedStatus(int.tryParse(friendId));
          return FriendActionType.block;
        }
        break;

      case FriendActionType.unfollow:
        return FriendActionType.unfollow;

      case FriendActionType.add:
        if (friendId != null && await onAddFriendRequest(friendId: friendId)) {
          return FriendActionType.add;
        }
        break;

      case FriendActionType.cancel:
        if (friendId != null && await onCancelFriendRequest(friendId: friendId)) {
          return FriendActionType.cancel;
        }
        break;

      case FriendActionType.confirm:
        if (requestId != null && await onAcceptRequest(requestId: requestId)) {
          return FriendActionType.confirm;
        }
        break;

      case FriendActionType.delete:
        if (requestId != null && await onRejectRequest(requestId: requestId)) {
          return FriendActionType.delete;
        }
        break;

      case FriendActionType.remove:
        if (friendId != null && await onRemoveFriendRequest(friendId: friendId)) {
          return FriendActionType.remove;
        }
        break;

      case FriendActionType.unblock:
        if (friendId != null && await onUnblockUser(friendId: friendId)) {
          return FriendActionType.unblock;
        }
        break;

      default:
        break;
    }

    return null;
  }



  /// -----------------------------
  /// Single Action API Helpers
  /// -----------------------------
  Future<bool> onAcceptRequest({required String requestId}) => _postAction(
    endpoint: APIEndPoints.confirmFriendRequest,
    body: {"request_id": requestId},
    successMsg: "Friend request accepted",
  );

  Future<bool> onRejectRequest({required String requestId}) => _postAction(
    endpoint: APIEndPoints.rejectFriendRequest,
    body: {"request_id": requestId},
    successMsg: "Friend request rejected",
  );

  Future<bool> onAddFriendRequest({required String friendId}) => _postAction(
    endpoint: APIEndPoints.addFriendRequest,
    body: {"friend_id": friendId},
    successMsg: "Friend request sent",
  );

  Future<bool> onCancelFriendRequest({required String friendId}) => _postAction(
    endpoint: APIEndPoints.cancelFriendRequest,
    body: {"friend_id": friendId},
    successMsg: "Friend request cancelled",
  );

  // remove from suggestion
  Future<bool> onRemoveFriendRequest({required String friendId}) => _postAction(
    endpoint: APIEndPoints.removeFriendRequestSuggestion,
    body: {"user_id": friendId},
    successMsg: "Friend request cancelled",
  );

  Future<bool> onUnfriend({required String friendId,bool showSnackBar=true}) => _postAction(
    endpoint: APIEndPoints.unfriendUser,
    body: {"friend_id": friendId},
    successMsg: "Unfriended successfully",
    showSnackBar: false
  );
  Future<bool> onBlockUser({required String friendId, bool showSnackBar=true}) => _postAction(
    endpoint: APIEndPoints.blockUser,
    body: {"user_id": friendId},
    successMsg: "User blocked",
    showSnackBar: showSnackBar
  );

  Future<bool> onUnblockUser({required String friendId}) => _postAction(
    endpoint: APIEndPoints.unblockUser,
    body: {"user_id": friendId},
    successMsg: "User unblocked",
  );

  Future<bool> _postAction({
    required String endpoint,
    required Map<String, dynamic> body,
    required String successMsg,
    bool showSnackBar = true,
  })
  async {
    isUpdating.value = true;
    try {
      final response = await RemoteServices.postRequest(endpoint: endpoint, body: body);
      if (response != null) {
       if(showSnackBar) CustomSnackBar(isSuccess: true, msg: response["msg"] ?? successMsg).showSnackBar();
        return true;
      }
      return false;
    } catch (e) {
      print("Post action error: $e");
      return false;
    } finally {
      isUpdating.value = false;
    }
  }


  /// -----------------------------
  /// Navigation
  /// -----------------------------
  void onDetails({required FriendsBasicInfoModel friend}) {
    final controller = Get.put(ProfileFeedController());
    controller.userId.value = friend.id.toString();
    controller.getProfileFeed();
    Get.toNamed(Routes.PROFILE_FEED);
  }

  /// -----------------------------
  /// Bottom Sheet
  /// -----------------------------

  Future<FriendActionType?> _openFriendMenu({
    required FriendsBasicInfoModel friend,
  }) async {

    final action = await Get.bottomSheet<FriendActionType>(
      CustomUserActionSheet(friend: friend),
      isDismissible: true,
      enableDrag: true,
    );

    if (action == null) return null;

    return await handleFriendAction(
      action: action,
      friendId: friend.id.toString(),
      friend: friend,
    );
  }
  /// -----------------------------
  /// Dispose
  /// -----------------------------
  @override
  void onClose() {
    _suggestionDebounce?.dispose();
    _incomingDebounce?.dispose();
    _sentDebounce?.dispose();
    _friendsDebounce?.dispose();
    super.onClose();
  }

*/
/*  void _updateBlockedStatus(int? userId) {
    if (userId == null) return;

    // 👉 My Friends list update
    final index = myFriends.indexWhere((e) => e.id == userId);
    if (index != -1) {
      var newFriend = myFriends[index].copyWith(friendshipStatus: FriendRequestStatus.blocked.name);
      myFriends[index] = newFriend;
    }
    // 👉 Refresh UI
    myFriends.refresh();
    friendSuggestions.refresh();
    friendRequestIncoming.refresh();
    friendRequestSent.refresh();
  }*//*


  void _updateBlockedStatus(int? userId) {
    if (userId == null) return;

    final index = myFriends.indexWhere((e) => e.id == userId);
    if (index != -1) {
      var updated = myFriends[index].copyWith(
        friendshipStatus: FriendRequestStatus.blocked.name,
      );
      myFriends[index] = updated;
    }

    /// refresh সব list (safe)
    myFriends.refresh();
    friendSuggestions.refresh();
    friendRequestIncoming.refresh();
    friendRequestSent.refresh();
  }

}*/


import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/utils/mixins.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../../stores/friends_store.dart';
import '../../../../utils/enums.dart';
import '../../../routes/app_pages.dart';
import '../../profileFeed/controllers/profile_feed_controller.dart';
import '../bindings/friends_binding.dart';
import '../models/friend_basic_info_model.dart';
import '../models/friend_request_incoming_model.dart';
import '../models/friend_suggestion_model.dart';
import '../models/my_friends_model.dart';
import '../models/single_friend_model.dart';
import '../views/friend_suggestions_view.dart';
import '../views/incoming_friend_request_view.dart';
import '../views/my_friends_view.dart';
import '../views/search_friends_view.dart';
import '../views/sent_requests_view.dart';
import '../widgets/custom_user_action_sheet.dart';

class FriendsController extends GetxController with ScrollLoadMoreMixin {

  /// -----------------------------
  /// States
  /// -----------------------------
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isUpdating = false.obs;

  /// -----------------------------
  /// 🔍 Search
  /// -----------------------------
  RxString suggestionSearch = ''.obs;
  RxString incomingSearch = ''.obs;
  RxString sentSearch = ''.obs;
  RxString myFriendsSearch = ''.obs;

  Worker? _suggestionDebounce;
  Worker? _incomingDebounce;
  Worker? _sentDebounce;
  Worker? _friendsDebounce;

  /// -----------------------------
  /// Init
  /// -----------------------------
  @override
  void onInit() {
    super.onInit();

    _suggestionDebounce = debounce(
      suggestionSearch,
          (_) => getFriendSuggestions(),
      time: const Duration(milliseconds: 500),
    );

    _incomingDebounce = debounce(
      incomingSearch,
          (_) => getFriendRequestIncoming(),
      time: const Duration(milliseconds: 500),
    );

    _sentDebounce = debounce(
      sentSearch,
          (_) => getFriendRequestSent(),
      time: const Duration(milliseconds: 500),
    );

    _friendsDebounce = debounce(
      myFriendsSearch,
          (_) => getMyFriends(),
      time: const Duration(milliseconds: 500),
    );
  }

  /// -----------------------------
  /// Navigation
  /// -----------------------------
  void goToSearchPage() {
    Get.to(() => SearchFriendsView(), binding: FriendSearchBinding());
  }


  Future<void> changeView({required FriendFilterType type}) async {
    isLoading.value = true;

    switch (type) {
      case FriendFilterType.suggestions:
        Get.to(() => FriendSuggestionsView());
        await getFriendSuggestions();
        break;
      case FriendFilterType.sent:
        Get.to(() => PendingFriendRequestView());
        await getFriendRequestSent();
        break;
      case FriendFilterType.incoming:
        Get.to(() => IncomingFriendRequestView());
        await getFriendRequestIncoming();
        break;
      case FriendFilterType.yourFriends:
        Get.to(() => MyFriendsView());
        await getMyFriends();
        break;
    }
    isLoading.value = false;
  }

  Future<void> initData() async {

    FriendStore.to.clearAll(); // 🔥 আগে clear 
    isLoading.value = true;
    try {
      await Future.wait([
        getFriendSuggestions(),
        getFriendRequestIncoming(),
        getFriendRequestSent(),
        getMyFriends(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }


  /// -----------------------------
  /// API → STORE
  /// -----------------------------
  Future<void> getFriendSuggestions() async {
    final res = await RemoteServices.getRequest(
      endpoint: APIEndPoints.getFriendSuggestions,
      parameters: {
        if (suggestionSearch.value.isNotEmpty)
          "query": suggestionSearch.value,
      },
    );

    if (res != null) {
      final model = FriendSuggestionModel.fromJson(res);

      FriendStore.to.setSuggestions(
        model.data?.suggestions ?? [],
      );
    }
  }

  Future<void> getFriendRequestIncoming() async {
    final res = await RemoteServices.getRequest(
      endpoint: APIEndPoints.getFriendRequestIncoming,
      parameters: {
        if (incomingSearch.value.isNotEmpty)
          "query": incomingSearch.value,
      },
    );

    if (res != null) {
      final model = FriendRequestIncomingModel.fromJson(res);

      FriendStore.to.setIncoming(
        model.data?.requests ?? [],
      );
    }
  }

  Future<void> getFriendRequestSent() async {
    final res = await RemoteServices.getRequest(
      endpoint: APIEndPoints.getFriendRequestSent,
      parameters: {
        if (sentSearch.value.isNotEmpty)
          "query": sentSearch.value,
      },
    );

    if (res != null) {
      final model = FriendRequestIncomingModel.fromJson(res);

      FriendStore.to.setSent(
        model.data?.requests ?? [],
      );
    }
  }

  Future<void> getMyFriends() async {
    final res = await RemoteServices.getRequest(
      endpoint: APIEndPoints.getMyFriends,
      parameters: {
        if (myFriendsSearch.value.isNotEmpty)
          "query": myFriendsSearch.value,
      },
    );

    if (res != null) {
      final model = MyFriendsModel.fromJson(res);

      /// convert basic -> SingleFriendModel
      final list = model.data?.friends?.map((e) {
        return SingleFriendModel(
          id: e.id,
          user: e,
        );
      }).toList() ?? [];

      FriendStore.to.setMyFriends(list);
    }
  }

  /// -----------------------------
  /// ACTION HANDLER (🔥 AUTO UPDATE)
  /// -----------------------------
  Future<FriendActionType?> handleFriendAction({
    required FriendActionType action,
    String? friendId,
     String? requestId,
    FriendsBasicInfoModel? friend,
  }) async {

    final id = int.tryParse(friendId ?? "");

    switch (action) {

      case FriendActionType.openMenu:
        return await _openFriendMenu(friend: friend!);

      case FriendActionType.add:
        if (await onAddFriendRequest(friendId: friendId!)) {
          FriendStore.to.updateStatus(id!, "sent");
          return action;
        }
        break;

      case FriendActionType.cancel:
        if (await onCancelFriendRequest(friendId: friendId!)) {
          FriendStore.to.updateStatus(id!, "");
          return action;
        }
        break;

      case FriendActionType.confirm:
        if (await onAcceptRequest(requestId: requestId!)) {
          FriendStore.to.updateStatus(id!, "friend");
          return action;
        }
        break;

      case FriendActionType.delete:
        if (await onRejectRequest(requestId: requestId!)) {
          FriendStore.to.updateStatus(id!, "");
          return action;
        }
        break;

      case FriendActionType.unfriend:
        if (await onUnfriend(friendId: friendId!)) {
          FriendStore.to.updateStatus(id!, "");
          return action;
        }
        break;

      case FriendActionType.block:
        if (await onBlockUser(friendId: friendId!)) {
          FriendStore.to.updateStatus(id!, "blocked");
          return action;
        }
        break;

      case FriendActionType.unblock:
        if (await onUnblockUser(friendId: friendId!)) {
          FriendStore.to.updateStatus(id!, "friend");
          return action;
        }
        break;

      default:
        break;
    }

    return null;
  }

  /// -----------------------------
  /// API HELPERS
  /// -----------------------------
  Future<bool> onAddFriendRequest({required String friendId}) =>
      _post(APIEndPoints.addFriendRequest, {"friend_id": friendId});

  Future<bool> onCancelFriendRequest({required String friendId}) =>
      _post(APIEndPoints.cancelFriendRequest, {"friend_id": friendId});

  Future<bool> onAcceptRequest({required String requestId}) =>
      _post(APIEndPoints.confirmFriendRequest, {"request_id": requestId});

  Future<bool> onRejectRequest({required String requestId}) =>
      _post(APIEndPoints.rejectFriendRequest, {"request_id": requestId});

  Future<bool> onUnfriend({required String friendId}) =>
      _post(APIEndPoints.unfriendUser, {"friend_id": friendId});

  Future<bool> onBlockUser({required String friendId}) =>
      _post(APIEndPoints.blockUser, {"user_id": friendId});

  Future<bool> onUnblockUser({required String friendId}) =>
      _post(APIEndPoints.unblockUser, {"user_id": friendId});

  Future<bool> _post(String endpoint, Map body) async {
    isUpdating.value = true;
    try {
      final res = await RemoteServices.postRequest(
        endpoint: endpoint,
        body: body,
      );
      if (res != null) {
        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"] ?? "Success",
        ).showSnackBar();
        return true;
      }
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// -----------------------------
  /// NAVIGATION
  /// -----------------------------
  void onDetails({required FriendsBasicInfoModel friend}) {
    final controller = Get.put(ProfileFeedController());
    controller.userId.value = friend.id.toString();
    controller.getProfileFeed();
    Get.toNamed(Routes.PROFILE_FEED);
  }

  /// -----------------------------
  /// MENU
  /// -----------------------------
  Future<FriendActionType?> _openFriendMenu({
    required FriendsBasicInfoModel friend,
  }) async {
    final action = await Get.bottomSheet<FriendActionType>(
      CustomUserActionSheet(friend: friend),
    );

    if (action == null) return null;

    return handleFriendAction(
      action: action,
      friendId: friend.id.toString(),
      friend: friend,
    );
  }

  @override
  void onClose() {
    _suggestionDebounce?.dispose();
    _incomingDebounce?.dispose();
    _sentDebounce?.dispose();
    _friendsDebounce?.dispose();
    super.onClose();
  }
}