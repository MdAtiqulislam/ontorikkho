import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/for_you_controller.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/page_feed_controller.dart';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import 'package:ontorikkho/app/modules/profileFeed/controllers/profile_feed_controller.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter/material.dart';
import '../../../../common_widgets/app_media_picker.dart';

class CreatePostController extends GetxController {
  /// text
  final text = ''.obs;
  final TextEditingController textController = TextEditingController();

  var isLoading = false.obs;

  /// media
  final selectedMedia = <XFile>[].obs; // image + video
  final RxMap<String, String> videoThumbnails = <String, String>{}.obs;

  var postProfileType = PostProfileType.profilePost;

  var user = UserData().obs;
  var pageDetails = PageDataModel().obs;

  bool get hasContent =>
      text.value.trim().isNotEmpty || selectedMedia.isNotEmpty;

  @override
  void onInit() async {
    super.onInit();
    textController.addListener(() {
      text.value = textController.text;
    });
    user.value = await LocalServices.getUserData() ?? UserData();
  }

  /// ✅ pick image + video
  Future<void> pickMedia() async {
    final List<XFile> mediaList = await AppMediaPicker.pickMedia(
      Get.context!,
      maxAssets: 100,
    );
    //await _picker.pickMultipleMedia();
    if (mediaList.isEmpty) return;
    selectedMedia.addAll(mediaList);
    for (final file in mediaList) {
      if (_isVideo(file.path)) {
        await generateThumbnail(file.path);
      }
    }
  }

  /// video check
  bool _isVideo(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv') ||
        lower.endsWith('.webm');
  }

  /// thumbnail generate
  Future<void> generateThumbnail(String videoPath) async {
    if (videoThumbnails.containsKey(videoPath)) return;

    final dir = await getTemporaryDirectory();
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: dir.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 300,
      quality: 75,
    );

    if (thumbPath != null) {
      videoThumbnails[videoPath] = thumbPath;
    }
  }

  Future<void> submitPost() async {
    isLoading.value = true;

    try {
      final endpoint =
          postProfileType == PostProfileType.profilePost
              ? APIEndPoints.createPost
              : APIEndPoints.createPagePost;

      /// convert XFile → File
      final mediaFiles = selectedMedia.map((x) => File(x.path)).toList();

      final res = await RemoteServices.createPostMultipart(
        endpoint: endpoint,
        content: text.value,
        associationId: "1",
        youtubeLink: "",
        mediaFiles: mediaFiles,
        pageId:
            postProfileType == PostProfileType.pagePost
                ? pageDetails.value.id.toString()
                : null,
      );

      if (res != null) {
        final forYou = Get.isRegistered<ForYouController>()
            ? Get.find<ForYouController>()
            : null;

        final profile = Get.isRegistered<ProfileFeedController>()
            ? Get.find<ProfileFeedController>()
            : null;

        final page = Get.isRegistered<PageFeedController>()
            ? Get.find<PageFeedController>()
            : null;

        if (postProfileType == PostProfileType.profilePost) {
          forYou?.fetchPosts();
          profile?.getProfileFeed();
        } else {
          page?.getPageDetails(id: pageDetails.value.id ?? 0);
        }

        Get.back();
        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"] ?? "Post created successfully",
        ).showSnackBar();
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(
        isSuccess: false,
        msg: "Something went wrong",
      ).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  void removeMedia(String path) {
    selectedMedia.removeWhere((m) => m.path == path);

    // যদি video thumbnail থাকে, সেটাও remove
    videoThumbnails.remove(path);
  }
}
