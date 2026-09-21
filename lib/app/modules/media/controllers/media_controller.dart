import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/media/models/photo_gallery_model.dart';
import 'package:ontorikkho/app/modules/media/models/video_gellary_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';

class MediaController extends GetxController with ScrollLoadMoreMixin{
  var selectedTab=0.obs;

  var isLoadingImages=false.obs;
  var isLoadingVideos=false.obs;

  var isLoadingMoreImages=false.obs;
  var isLoadingMoreVideos=false.obs;

  var images=<SingleImage>[].obs;

  var photoGalleryPagination=Pagination().obs;
  var videoGalleryPagination=Pagination().obs;


final ScrollController imageScrollController=ScrollController();
final ScrollController videoScrollController=ScrollController();

  final videoList = <SingleVideo>[].obs;



  @override
  void onInit() async {
    super.onInit();
    await _getPhotos();
    await _getVideos();
  }

  @override
  void onReady() {
    super.onReady();
    setupLoadMore(
      controller: imageScrollController,
      isLoadingMore: isLoadingMoreImages,
     // nextPageUrl: photoGalleryPagination.value.nextPageUrl,
      onLoadMore: () {
        final url = photoGalleryPagination.value.nextPageUrl;
        if (url != null) {
          loadMoreImage(url: url);
        }
      },
    );

    setupLoadMore(
      controller: videoScrollController,
      isLoadingMore: isLoadingMoreVideos,
      //nextPageUrl: videoGalleryPagination.value.nextPageUrl,
      onLoadMore: () {
        final url = videoGalleryPagination.value.nextPageUrl;
        if (url != null) {
          loadMoreVideos(url: url);
        }
      },
    );
  }


 Future<void> _getPhotos() async{
    isLoadingImages.value=true;
    var endpoint=APIEndPoints.getImages;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);

      if(rs!=null){
        var photoGalleryModel=PhotoGalleryModel.fromJson(rs);
        images.value=photoGalleryModel.data??[];
        photoGalleryPagination.value=photoGalleryModel.pagination??Pagination();
      }
    } finally {
      isLoadingImages.value=false;
    }
  }


  Future<void> loadMoreImage({required String url}) async {
    isLoadingMoreImages.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);
      if (rs != null) {
        PhotoGalleryModel photoGalleryModel = PhotoGalleryModel.fromJson(rs);
        photoGalleryPagination.value = photoGalleryModel.pagination ?? Pagination();
        images.addAll(photoGalleryModel.data??[]);

      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMoreImages.value = false;
    }
  }

  Future<void> _getVideos() async{
    isLoadingVideos.value=true;
    var endpoint=APIEndPoints.getVideos;
    try {
      var rs=await RemoteServices.getRequest(endpoint: endpoint);

      if(rs!=null){
        var videoGalleryModel=VideoGalleryModel.fromJson(rs);
        videoList.value=videoGalleryModel.data??[];
        videoGalleryPagination.value=videoGalleryModel.pagination??Pagination();
      }
    } finally {
      isLoadingVideos.value=false;
    }
  }



  Future<void> loadMoreVideos({required String url}) async {
    isLoadingMoreVideos.value = true;
    try {
      final rs = await RemoteServices.getRequestLoadMore(url: url);
      if (rs != null) {
        VideoGalleryModel videoGalleryModel = VideoGalleryModel.fromJson(rs);
        photoGalleryPagination.value = videoGalleryModel.pagination ?? Pagination();
        videoList.addAll(videoGalleryModel.data??[]);

      }
    } catch (e) {
      if (kDebugMode) {
        print('LoadMore error: $e');
      } // ✅ Optional: handle error properly
    } finally {
      isLoadingMoreVideos.value = false;
    }
  }



}
