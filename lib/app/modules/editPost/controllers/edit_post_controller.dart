import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../common_widgets/app_media_picker.dart';
import '../../../../services/remote_services.dart';
import '../../pages/models/page_data_model.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';

class EditPostController extends GetxController {

  var post = SinglePostModel().obs;
  var postProfileType=PostProfileType.profilePost;

  var user = UserData().obs;
  var pageDetails = PageDataModel().obs;

  var removedMediaIds = <String>[];

  var text="".obs;
  /// Newly picked local media
  final RxList<Media> localMedia = <Media>[].obs;

  /// Existing server media
  final RxList<Media> originalMedia = <Media>[].obs;

  /// Combined list for UI
  final RxList<Media> totalMedia = <Media>[].obs;

  /// Video thumbnails
  final RxMap<String, String> videoThumbnails = <String, String>{}.obs;

  final isLoading = false.obs;

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      text.value = textController.text;
    });
    loadMedia();
  }

  /// Load post existing media
  void loadMedia() {
    originalMedia.assignAll(post.value.media ?? []);
    textController.text=post.value.content??"";
    _rebuildTotalMedia();
  }

  /// Pick new media (no duplicates)
  Future<void> pickMedia() async {
    final picked = await AppMediaPicker.pickMedia(Get.context!);
    if (picked.isEmpty) return;

    for (final file in picked) {
      final alreadyExists = totalMedia.any((m) => m.url == file.path);
      if (alreadyExists) continue;

      localMedia.add(
        Media(
          url: file.path,
          type: _isVideo(file.path) ? "video" : "image",
        ),
      );

      if (_isVideo(file.path)) {
        generateThumbnail(file.path);
      }
    }

    _rebuildTotalMedia();
  }

  /// Remove media safely
  void removeMedia(Media media) {
    // Remove from localMedia
    localMedia.removeWhere((e) => e.url == media.url);

    // Check and remove from originalMedia
    final removed = originalMedia.firstWhereOrNull((e) => e.url == media.url);
    if (removed != null) {
      originalMedia.remove(removed);

      // Add its id to removedMediaIds if id exists
      if (removed.id != null) {
        removedMediaIds.add(removed.id.toString());
      }
    }
    _rebuildTotalMedia();
  }

  /// Rebuild combined list (🔥 MOST IMPORTANT)
  void _rebuildTotalMedia() {
    totalMedia.assignAll([
      ...originalMedia,
      ...localMedia,
    ]);
  }

  /// Generate video thumbnail
  Future<void> generateThumbnail(String path) async {
    // your existing implementation
  }

  bool _isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.mkv');
  }

  RxBool get hasContent =>
     RxBool( text.isNotEmpty ||
         totalMedia.isNotEmpty);

  Future<void> updatePost() async {
    if (post.value.id == null) return;

    isLoading.value = true;

    try {
      final result = await RemoteServices.updatePostMultipart(
        endpoint: APIEndPoints.updatePost,
        postId: post.value.id.toString(),
        content: text.value.trim(),
        associationId: "1",
        youtubeLink: post.value.youtubeLink??"",
        existingMedia: originalMedia,
        removeMediaIds: removedMediaIds,
        newMediaFiles: localMedia.map((m) => File(m.url!)).toList(),
        removeAllMedia: false,
      );

      if (result != null) {
        final updatedPost = post.value.copyWith(
          content: text.value.trim(),
          media: [...originalMedia, ...localMedia],
        );


        Get.back(result: updatedPost);
      }
    } finally {
      isLoading.value = false;
    }
  }



}
