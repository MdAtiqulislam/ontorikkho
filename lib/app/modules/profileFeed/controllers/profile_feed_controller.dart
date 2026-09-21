
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/mixins.dart';

import '../../../../models/pagination_model.dart';
import '../../../../services/remote_services.dart';
import '../../../../stores/post_store.dart';
import '../../forYou/models/posts_model.dart';
import '../../friends/controllers/friends_controller.dart';
import '../models/profile_feed_model.dart';


class ProfileFeedController extends GetxController with ScrollLoadMoreMixin {
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isLoadingMore = false.obs;
  var posts = <int>[].obs;
  var pagination = Pagination().obs;
  var profileData = ProfileDataModel().obs;
  var scrollController = ScrollController();
  var friendshipStatus = "".obs;
  var requestId = "".obs;
  var userId = "".obs;
  var user = UserData();
  var isOwner = false.obs;
  var selectedProfileImage = RxnString();
  var selectedCoverImage = RxnString();
  final ImagePicker picker = ImagePicker();
 // var myPages=<PageModel>[].obs;


  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
    //  nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {
        final url = pagination.value.nextPageUrl;
        if (url != null) loadMore(url: url);
      },
    );
  }

  /// ================= COMMON LOADER =================
  Future<T?> _handleLoading<T>({
    required RxBool loader,
    required Future<T?> Function() request,
  })
  async {
    loader.value = true;
    try {
      return await request();
    } finally {
      loader.value = false;
    }
  }

  /// ================= PROFILE FEED =================
  Future<void> getProfileFeed() async
  {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        var res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.profileFeed,
          parameters: {"user_id": userId.value},
        );

        if (res == null) return null;

        final model = ProfileFeedModel.fromJson(res);

        friendshipStatus.value = model.friendshipStatus ?? "";
        requestId.value = model.requestId?.toString() ?? "";

        PostStore.to.setPosts(model.posts ?? []);
        posts.value = (model.posts ?? []).map((e) => e.id!).toList();

        pagination.value = model.pagination ?? Pagination();
        profileData.value = model.profileData ?? ProfileDataModel();

        user = await LocalServices.getUserData() ?? UserData();
        isOwner.value = userId.value == user.userId.toString();

       // if(isOwner.value)await getMyPages();

        return null;
      },
    );
  }

  /// ================= LOAD MORE =================
  Future<void> loadMore({required String url}) async
  {
    await _handleLoading(
      loader: isLoadingMore,
      request: () async {
        final res = await RemoteServices.getRequestLoadMore(url: url);

        if (res == null) return null;

        final postsModel = PostsModel.fromJson(res);

        PostStore.to.setPosts(postsModel.posts ?? []);
        posts.addAll((postsModel.posts ?? []).map((e) => e.id!));

        pagination.value = postsModel.pagination ?? Pagination();

        return null;
      },
    );
  }

  Future<void> refreshPosts() async => getProfileFeed();

  /// ================= IMAGE UPLOAD (COMMON) =================
  Future<void> _uploadImage({
    required String path,
    required String endpoint,
    required String fieldName,
  }) async {
    await _handleLoading(
      loader: isUpdating,
      request: () async {
        var res = await RemoteServices.multipartRequest(
          endpoint: endpoint,
          filePath: path,
          fieldName: fieldName,
          requestType: 'POST',
        );

        if (res != null) {
          await getProfileFeed();
        }

        return null;
      },
    );
  }

  /// ================= PROFILE PHOTO =================
  Future<void> updateProfilePicture(ImageSource source) async {
    final image = await picker.pickImage(source: source, imageQuality: 80);
    if (image == null) return;

    selectedProfileImage.value = image.path;

    await _uploadImage(
      path: image.path,
      endpoint: APIEndPoints.updateProfilePhoto,
      fieldName: 'profile_picture',
    );
  }

  /// ================= COVER PHOTO =================
  Future<void> updateCoverPhoto(ImageSource source) async {
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image == null) return;

    selectedCoverImage.value = image.path;

    await _uploadImage(
      path: image.path,
      endpoint: APIEndPoints.updateCoverPhoto,
      fieldName: 'cover_photo',
    );
  }

  /// ================= FRIEND MENU =================
  Future<void> handelOpenFriendMenu() async {
    await _handleLoading(
      loader: isUpdating,
      request: () async {
        var friend = FriendsBasicInfoModel().copyWith(
          id: int.tryParse(userId.value),
          name: profileData.value.personalData?.name,
          email: profileData.value.personalData?.email,
          phone: profileData.value.personalData?.mobile,
          address: profileData.value.personalData?.permanentAddress,
          avatar: profileData.value.profilePicture,
          friendshipStatus: friendshipStatus.value,
        );

        var result = await Get.find<FriendsController>().handleFriendAction(
          friend: friend,
          action: FriendActionType.openMenu,
        );

        if (result != null) updateStatus(result);

        return null;
      },
    );
  }

  /// ================= STATUS UPDATE =================
  void updateStatus(FriendActionType result) {
    const statusMap = {
      FriendActionType.add: "sent",
      FriendActionType.cancel: "",
      FriendActionType.confirm: "friend",
      FriendActionType.delete: "",
      FriendActionType.unfriend: "",
      FriendActionType.block: "blocked",
      FriendActionType.unblock: "friend",
    };

    friendshipStatus.value =
        statusMap[result] ?? friendshipStatus.value;
  }
}