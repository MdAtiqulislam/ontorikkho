import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/friends/models/my_friends_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../utils/enums.dart';
import '../../forYou/models/posts_model.dart';
import '../../friends/models/friend_basic_info_model.dart';

class SharePostController extends GetxController {
  SharePostController({
    required this.post,
  });

  final SinglePostModel post;

  final isLoading = false.obs;
  final friends = <FriendsBasicInfoModel>[].obs;

  TextEditingController cationController = TextEditingController();

  var user=UserData().obs;

  @override
  onInit() {
    super.onInit();
    loadRecentFriends();
    getUserData();
  }

  Future<bool> sharePost({
    required ShareType shareType,
    String? caption,
    String? friendUserId,
  }) async {
    isLoading.value = true;

    try {
      final body = <String, dynamic>{
        "post_id": post.id.toString(),
        "share_type": shareType.value,
      };

      if ((caption ?? "").trim().isNotEmpty) {
        body["caption"] = caption!.trim();
      }

      if (shareType == ShareType.shareWithFriend) {
        body["friend_user_id"] = friendUserId;
      }

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.postShare,
        body: body,
      );

      return res != null;

    } finally {
      isLoading.value = false;
    }
  }

  /// Share to Wall
  Future<void> shareToWall({
    String? caption,
  }) async
  {
    final success = await sharePost(
      shareType: ShareType.shareToWall,
      caption: caption,
    );

    if (!success) return;

    Get.back();

    CustomSnackBar(
      isSuccess: true,
      msg: "Post shared to wall successfully."
    ).showSnackBar();
  }

  /// Share with Friend
  Future<void> shareToFriend({
    required String friendId,
    String? caption,
  }) async
  {
    final success = await sharePost(
      shareType: ShareType.shareWithFriend,
      friendUserId: friendId,
      caption: caption,
    );

    if (!success) return;

    Get.back();

    // Snackbar.success(...)
  } /// Share with Friend
  ///
  ///
  Future<void> shareLink() async
  {
    final success = await sharePost(
      shareType: ShareType.shareLink,
    );

    if (!success) return;

    Get.back();
    CustomSnackBar(
      isSuccess: true,
      msg: "Link shared successfully."
    ).showSnackBar();
  }

  /// Copy Link
  Future<void> copyLink() async
  {
    final success = await sharePost(
      shareType: ShareType.shareLink,
    );

    if (!success) return;

    final link = post.deepLink ?? "";

    if (link.isNotEmpty) {
      await Clipboard.setData(
        ClipboardData(text: link),
      );
    }

    Get.back();
    CustomSnackBar(
      isSuccess: true,
      msg: "Link copied to clipboard."
    ).showSnackBar();
  }



  /// Share post
  void shareExternal() {
    String shareText = _buildShareText(post);

    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: "Check this out",
      ),
    );
  }

  String _buildShareText(SinglePostModel post) {
    String contentText = post.content?.trim() ?? "";
    if (contentText.length > 100) {
      contentText = "${contentText.substring(0, 100)}...";
    }

    String? mediaLink;
    if (post.mediaPath != null && post.mediaPath!.isNotEmpty) {
      mediaLink = post.mediaPath;
    } else if (post.youtubeLink != null && post.youtubeLink!.isNotEmpty) {
      mediaLink = post.youtubeLink;
    }

    final buffer = StringBuffer();
    if (contentText.isNotEmpty) {
      buffer.writeln(contentText);
      buffer.writeln();
    }
    if (mediaLink != null) {
      buffer.writeln(mediaLink);
      buffer.writeln();
    }
    buffer.write("Shared via Ontorikkho");
    return buffer.toString();
  }



  Future<void> loadRecentFriends() async {
    isLoading.value=true;
    var endpoint=APIEndPoints.getMyFriends;
    var res=await RemoteServices.getRequest(endpoint: endpoint);
    try {
      if(res!=null){
        var model=MyFriendsModel.fromJson(res);

        friends.value=model.data?.friends ?? [];
      }
    } finally {
      isLoading.value=false;
    }

  }

  Future<void> getUserData() async {
    await LocalServices.getUserData().then((value) {
      if (value != null) {
        user.value = value;
      }
    });
  }


}