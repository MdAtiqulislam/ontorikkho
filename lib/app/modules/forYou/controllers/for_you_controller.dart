
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/models/single_comment.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_request_incoming_model.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/logged_in_user_model.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../models/pagination_model.dart';
import '../../../../stores/friends_store.dart';
import '../../../../stores/post_store.dart';
import '../../../routes/app_pages.dart';
import '../../editPost/controllers/edit_post_controller.dart';
import '../../editPost/views/edit_post_view.dart';
import '../../friends/models/friend_suggestion_model.dart';
import '../../friends/models/single_friend_model.dart';
import '../../profileFeed/controllers/profile_feed_controller.dart';

class ForYouController extends GetxController with ScrollLoadMoreMixin {

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isLoadingMore = false.obs;
  var isLoadingFriends = false.obs;

  /// Post order
  var posts = <int>[].obs;
 var friendSuggestions=<SingleFriendModel>[].obs;
  var pagination = Pagination().obs;

  final ScrollController scrollController = ScrollController();

  var user=UserData().obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchPosts();
    await fetchFriendSuggestions();
    user.value=await LocalServices.getUserData()??UserData();
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

  /// Refresh feed
  Future<void> refreshPosts() async {
    await fetchPosts();
    await fetchFriendSuggestions();
  }

  /// Fetch initial posts
  Future<void> fetchPosts() async {
    isLoading.value = true;
    var endpoint = APIEndPoints.getPosts;
    try {
      var res = await RemoteServices.getRequest(endpoint: endpoint);
      if (res != null) {
        PostsModel postsModel = PostsModel.fromJson(res);

        /// Save globally
        PostStore.to.setPosts(postsModel.posts ?? []);

        /// Local list keeps order
        posts.assignAll(
          (postsModel.posts ?? []).map((e) => e.id!).toList(),
        );

        pagination.value = postsModel.pagination ?? Pagination();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete post
  Future<void> deletePost({required String id}) async {
    isUpdating.value = true;
    try {
      var res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.deletePost,
        body: {"id": id},
      );

      if (res != null) {
        PostStore.to.removePost(int.parse(id));
        posts.removeWhere((pid) => pid == int.parse(id));

        CustomSnackBar(isSuccess: true, msg: res["msg"]).showSnackBar();
      } else {
        CustomSnackBar(
            isSuccess: false,
            msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  /// Edit post
  Future<void> editPost({required SinglePostModel post,}) async {
   // Get.delete<EditPostController>(force: true);
    Get.put(EditPostController()).post.value = post;
    Get.find<EditPostController>().loadMedia();

    final SinglePostModel? updatedPost = await Get.to(() => EditPostView());
    if (updatedPost == null) return;

    PostStore.to.updatePost(updatedPost);

  }

  /// Load more posts
  Future<void> loadMore({required String url}) async {
    isLoadingMore.value = true;
    try {
      final res = await RemoteServices.getRequestLoadMore(url: url);
      if (res != null) {
        PostsModel postsModel = PostsModel.fromJson(res);

        PostStore.to.setPosts(postsModel.posts ?? []);

        posts.addAll((postsModel.posts ?? []).map((e) => e.id!).toList());
        pagination.value = postsModel.pagination ?? Pagination();
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Update post comments globally
  void updatePostComments(int postId, List<SingleComment> comments) {
    final post = PostStore.to.getPost(postId);
    if (post == null) return;

    final updatedPost = post.copyWith(comments: comments);
    PostStore.to.updatePost(updatedPost);
  }

  Future<void> fetchFriendSuggestions() async{
    isLoadingFriends.value=true;
    var endpoint=APIEndPoints.getFriendSuggestions;
    try {
      var response=await RemoteServices.getRequest(endpoint: endpoint);
      if(response!=null){
        var model=FriendSuggestionModel.fromJson(response);
      //  friendSuggestions.value=model.data?.suggestions??[];
        FriendStore.to.setSuggestions(model.data?.suggestions ?? []);
      }
    } finally {
      isLoadingFriends.value=false;
    }
  }

  void onDetails({required FriendsBasicInfoModel friend}) {
    final controller = Get.put(ProfileFeedController());
    controller.userId.value = friend.id.toString() ;
    controller.getProfileFeed();
    Get.toNamed(Routes.PROFILE_FEED);
  }

  Future<void>onRemoveFriendRequest({required int friendId}) async{
    try {
      var response=await RemoteServices.postRequest(
          endpoint: APIEndPoints.removeFriendRequestSuggestion,
          body: {
            "friend_id":friendId,
          }
      );
      if(response!=null){
        CustomSnackBar(isSuccess: true, msg: response["msg"]??"").showSnackBar();
        await fetchFriendSuggestions();
      }
    } finally {

    }
  }



  Future<bool> onAddFriendRequest({required int friendId}) {
    isUpdating.value=true;
    var endpoint=APIEndPoints.addFriendRequest;
    var body={
      "friend_id":friendId.toString()
    };

    return RemoteServices.postRequest(endpoint: endpoint,body: body).then((response) async {
      if(response!=null){
        await fetchFriendSuggestions();
        CustomSnackBar(
          isSuccess: true,
          msg: response["msg"] ?? "Friend request rejected",
        ).showSnackBar();
        return true;
      }
      return false;
    }).catchError((error){
      return false;
    }).whenComplete(() => isUpdating.value=false);
  }

  Future<bool> onCancelFriendRequest({required int friendId}) {
    isUpdating.value=true;
    var endpoint=APIEndPoints.cancelFriendRequest;
    var body={
      "friend_id":friendId.toString()
    };

    return RemoteServices.postRequest(endpoint: endpoint,body: body).then((response) async {
      if(response!=null){
        await fetchFriendSuggestions();
        CustomSnackBar(
          isSuccess: true,
          msg: response["msg"] ?? "Friend request rejected",
        ).showSnackBar();
        return true;
      }
      return false;
    }).catchError((error){
      return false;
    }).whenComplete(() => isUpdating.value=false);
  }

}