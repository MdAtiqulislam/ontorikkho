import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/editPost/controllers/edit_post_controller.dart';
import 'package:ontorikkho/app/modules/pageFeed/models/page_details_model.dart';
import 'package:ontorikkho/app/modules/pageFeed/models/page_images_model.dart';
import 'package:ontorikkho/app/modules/pageFeed/models/page_videos_model.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../models/pagination_model.dart';
import '../../../../services/my_pages_service.dart';
import '../../../../stores/post_store.dart';
import '../../../../utils/mixins.dart';
import '../../../routes/app_pages.dart';
import '../../forYou/models/posts_model.dart';
import '../../friends/models/friend_basic_info_model.dart';

class PageFeedController extends GetxController with ScrollLoadMoreMixin {
  var isLoading = false.obs;
  var isLoadingMedia = false.obs;
  var isUpdating = false.obs;
  var isLoadingMore = false.obs;
  var isLoadingMoreImages = false.obs;
  var isLoadingMoreVideos = false.obs;
  var posts = <int>[].obs;
  var pagination = Pagination().obs;
  var pageData = PageDataModel().obs;
  var scrollController = ScrollController();
  var followerCount = 0.obs;
  var mutuleCount = 0.obs;
  var mutuleFriends = <FriendsBasicInfoModel>[].obs;
  var selectedProfileImage = RxnString();
  var selectedCoverImage = RxnString();
  final ImagePicker picker = ImagePicker();
  var pageImages = <Media>[].obs;
  var pageVideos = <Media>[].obs;


  var pageId = 0;

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
      //  nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: () {
        final url = pagination.value.nextPageUrl;
        if (url != null) loadMore(url: url);
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadMore({required String url}) async {
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

  Future<void> getPageDetails({required int id}) async {
    pageId = id;
    await _handleLoading(
      loader: isLoading,
      request: () async {
        var res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getPageDetails,
          parameters: {"page_id": id.toString()},
        );
        if (res == null) return null;
        var model = PageDetailsModel.fromJson(res);
        pageData.value = model.data?.page ?? PageDataModel();
        pagination.value = model.data?.pagination ?? Pagination();
        followerCount.value = model.data?.followerCount ?? 0;
        mutuleCount.value = model.data?.mutualCount ?? 0;
        mutuleFriends.value = model.data?.mutualMembers ?? [];

        PostStore.to.setPosts(model.data?.posts ?? []);
        posts.value = (model.data?.posts ?? []).map((e) => e.id!).toList();
        Get.put(EditPostController()).postProfileType=PostProfileType.pagePost;
        Get.find<EditPostController>().pageDetails=pageData;
        return null;
      },
    );
  }

  Future<void> getPageImages({required int id}) async {
    pageId = id;
    await _handleLoading(
      loader: isLoadingMedia,
      request: () async {
        var res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getPageImages,
          parameters: {"page_id": id.toString()},
        );
        if (res == null) return null;
        var model = PageImagesModel.fromJson(res);
        pageImages.value = model.photoList ?? [];
        return null;
      },
    );
  }

  Future<void> getPageVideos({required int id}) async {
    pageId = id;
    await _handleLoading(
      loader: isLoadingMedia,
      request: () async {
        var res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getPageVideos,
          parameters: {"page_id": id.toString()},
        );
        if (res == null) return null;
        var model = PageVideosModel.fromJson(res);
        pageImages.value = model.videoList ?? [];
        return null;
      },
    );
  }

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

  /// ================= PROFILE PHOTO =================
  Future<void> updateProfilePicture(ImageSource source) async {
    final image = await picker.pickImage(source: source, imageQuality: 80);
    if (image == null) return;

    selectedProfileImage.value = image.path;

    await _uploadImage(
      path: image.path,
      endpoint: APIEndPoints.updatePageProfilePhoto,
      fieldName: 'profile_picture',
      body: {"page_id": pageId.toString()},
    ).then((value) async {
      if(value){
        /*if (Get.isRegistered<ProfileFeedController>()) {
          await Get.find<ProfileFeedController>().getMyPages();
        }*/
        Get.find<MyPageService>().refresh();
      }
    });
  }

  /// ================= COVER PHOTO =================
  Future<void> updateCoverPhoto(ImageSource source) async {
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image == null) return;

    selectedCoverImage.value = image.path;

    await _uploadImage(
      path: image.path,
      endpoint: APIEndPoints.updatePageCoverPhoto,
      fieldName: 'cover_photo',
      body: {"page_id": pageId.toString()},
    ).then((value) async {
      if(value){
        /*if (Get.isRegistered<ProfileFeedController>()) {
          await Get.find<ProfileFeedController>().getMyPages();

        }*/
        Get.find<MyPageService>().refresh();
      }
    });
  }

  /// ================= IMAGE UPLOAD (COMMON) =================
  Future<bool> _uploadImage({
    required String path,
    required String endpoint,
    required String fieldName,
    required Map<String, String> body,
  }) async {
    return await _handleLoading<bool>(
          loader: isUpdating,
          request: () async {
            var res = await RemoteServices.multipartRequest(
              endpoint: endpoint,
              filePath: path,
              fieldName: fieldName,
              requestType: 'POST',
              body: body,
            );

            if (res != null) {
              await getPageDetails(id: pageId);
              return true;
            }
            return false;
          },
        ) ??
        false;
  }

  Future<void> deletePage({required int pageId}) async {
    isUpdating.value = true;
    var endpoint=APIEndPoints.deletePage;
    var body={
      "page_id": pageId.toString()
    };
    try {
      var res=await RemoteServices.postRequest(endpoint: endpoint, body: body);
      if(res!=null){

        Get.find<MyPageService>().removePage(pageId);

        Get.offAndToNamed(Routes.PAGES);
        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"]
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }
}
