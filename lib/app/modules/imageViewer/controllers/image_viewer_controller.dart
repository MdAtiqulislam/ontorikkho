/*
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/media/models/photo_gallery_model.dart';

class ImageViewerController extends GetxController {

   List<SingleImage> imageList=[];
   List<String> imageUrlList=[];
  int initialIndex=0;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
*/


import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/media/models/photo_gallery_model.dart';

class ImageViewerController extends GetxController {
  // Either a list of SingleImage objects
  List<SingleImage> imageList = [];

  // Or a list of image URLs
  List<String> imageUrlList = [];

  // Starting index
  int initialIndex = 0;

  // Current index of the displayed image
  var currentIndex = 0.obs;

  /// Initialize with images
  void setImages({List<SingleImage>? images, List<String>? urls, int startIndex = 0}) {
    imageList = images ?? [];
    imageUrlList = urls ?? [];
    initialIndex = startIndex;
    currentIndex.value = startIndex;
  }

  /// Get current image URL
  String get currentImageUrl {
    if (imageList.isNotEmpty) {
      return imageList[currentIndex.value].photo ?? "";
    } else if (imageUrlList.isNotEmpty) {
      return imageUrlList[currentIndex.value];
    }
    return "";
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}