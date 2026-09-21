import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pageFeed/views/add_admin_bottom_sheet.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/app/modules/pages/models/page_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/user_model.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../friends/models/search_friend_model.dart';
import '../models/page_admins_model.dart';

class ManageAdminController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isUpdating = false.obs;
  var admins = <Admin>[].obs;
  var page = PageDataModel().obs;

  final searchController = TextEditingController();

  final searchText = "".obs;
  final searchedFriends = <SearchUser>[].obs;
  final isSearching = false.obs;

  late Worker _searchDebouncer;

  var user=UserData().obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
    _searchDebouncer = debounce<String>(searchText, (value) {
      searchFriend(value);
    }, time: const Duration(milliseconds: 500));
  }

  Future<void>getUser()async{
    await LocalServices.getUserData().then((value){
      user.value=value??UserData();
    });
  }

  @override
  void onClose() {
    _searchDebouncer.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> getAdmins({required String pageId}) async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getAdmins;
    var parameters = {"page_id": pageId};

    try {
      var res = await RemoteServices.getRequest(
        endpoint: endpoint,
        parameters: parameters,
      );

      if (res != null) {
        var model = PageAdminsModel.fromJson(res);
        admins.value = model.data?.admins ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  void showAddAdminBottomSheet() {
    showCustomBottomSheet(title: "Add Admin", content: AddAdminBottomSheet());
  }

  Future<void> searchFriend(String keyword) async {
    keyword = keyword.trim();

    if (keyword.isEmpty) {
      searchedFriends.clear();
      return;
    }

    isSearching.value = true;

    try {
      final res = await RemoteServices.getRequest(
        endpoint: APIEndPoints.searchFriendsForAdminRul,
        parameters: {
          "search_text": keyword,
          "page_id": page.value.id.toString(),
        },
      );

      if (res == null) return;

      final model = SearchFriendModel.fromJson(res);

      searchedFriends.assignAll(model.data?.users ?? []);
    } catch (e) {
      debugPrint("Search Friend Error : $e");
      print(e);
      searchedFriends.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void updateItemStatus({
    required int index,
    required FriendActionType action,
  })
  {
    final oldItem = searchedFriends[index];
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
    final updatedUser = oldUser.copyWith(friendshipStatus: newStatus);

    /// ✅ replace item
    searchedFriends[index] = oldItem.copyWith(
      user: updatedUser,
      isFriend: newStatus == "friend",
    );

    searchedFriends.refresh();
  }

  Future<void> addAdmin({required String userId, required int index}) async {
    isUpdating.value = true;

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.addAdmin,
        body: {
          "page_id": page.value.id.toString(),
          "user_id": userId,
          "role": "admin",
        },
      );

      if (res != null) {
        final oldItem = searchedFriends[index];

        searchedFriends[index] = oldItem.copyWith(userRole: "Admin");
        await getAdmins(pageId: page.value.id.toString());

        searchedFriends.refresh();

        CustomSnackBar(isSuccess: true, msg: res["msg"]).showSnackBar();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> removeAdmin({
    required String userId,
    required String pageId,
    int? searchIndex,
  }) async
  {
    isUpdating.value = true;

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.removeAdmin,
        body: {
          "page_id": pageId,
          "user_id": userId,
        },
      );

      if (res != null) {
        admins.removeWhere(
              (admin) => admin.user?.id.toString() == userId,
        );

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"] ?? "Admin removed successfully.",
        ).showSnackBar();
      }
    } catch (e) {
      debugPrint("Remove Admin Error: $e");

      CustomSnackBar(
        isSuccess: false,
        msg: "Failed to remove admin.",
      ).showSnackBar();
    } finally {
      isUpdating.value = false;
    }
  }
}
