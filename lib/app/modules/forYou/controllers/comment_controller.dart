
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/models/comments_model.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/services/local_services.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/stores/post_store.dart';

import '../models/single_comment.dart';

class CommentsController extends GetxController {

  /// ================= CORE STATE =================
  final isLoading = false.obs;

  int postId = 0;

  final comments = <SingleComment>[].obs;
  final pagination = Pagination().obs;

  final userData = UserData().obs;

  /// reply open state
  final showReplyMap = <String, bool>{}.obs;

  /// edit state
  final isEditingMap = <String, bool>{}.obs;

  /// controllers
  final replyControllers = <String, TextEditingController>{};
  final editControllers = <String, TextEditingController>{};

  /// ================= LIFECYCLE =================

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userData.value =
        await LocalServices.getUserData() ?? UserData();
  }

  @override
  void onClose() {
    for (final c in replyControllers.values) {
      c.dispose();
    }
    for (final c in editControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  /// ================= HELPERS =================

  TextEditingController replyCtrl(String id) =>
      replyControllers.putIfAbsent(
          id, () => TextEditingController());

  TextEditingController editCtrl(String id) =>
      editControllers.putIfAbsent(
          id, () => TextEditingController());

  bool isReplyOpen(String id) =>
      showReplyMap[id] ?? false;

  bool isEditing(String id) =>
      isEditingMap[id] ?? false;

  void toggleReply(String id) {
    showReplyMap[id] = !(showReplyMap[id] ?? false);
  }

  void startEdit(String id, String text) {
    editCtrl(id).text = text;
    isEditingMap[id] = true;
  }

  void stopEdit(String id) {
    isEditingMap[id] = false;
  }

  /// ================= POST STORE UPDATE =================

  void updatePostComments() {

    final post = PostStore.to.getPost(postId);

    if (post == null) return;

    final updatedPost = post.copyWith(
      comments: comments.value,
    );

    PostStore.to.posts[postId] = updatedPost;

    PostStore.to.posts.refresh();
    print(post.comments.toString());

  }

  /// ================= LOAD COMMENTS =================

  Future<void> loadComments({int? id}) async {

    isLoading.value = true;

    try {

      if (id != null) {
        postId = id;
      }

      final res = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getComments,
        parameters: {"post_id": postId.toString()},
      );

      if (res != null) {

        final model = CommentsModel.fromJson(res);

        comments.value = model.data ?? [];

        pagination.value =
            model.pagination ?? Pagination();

        /// ⭐ update poststore
        updatePostComments();
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= ADD COMMENT =================

  Future<void> addComment(String text) async {

    if (text.trim().isEmpty) return;

    isLoading.value = true;

    try {

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.addComment,
        body: {
          "post_id": postId.toString(),
          "content": text,
        },
      );

      if (res != null) {

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"],
        ).showSnackBar();

        await loadComments();
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= EDIT COMMENT =================

  Future<void> editComment(String id, String newText) async {

    isLoading.value = true;

    try {

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.updateComment,
        body: {"id": id, "content": newText},
      );

      if (res != null) {

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"],
        ).showSnackBar();

        await loadComments();

        stopEdit(id);
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= DELETE COMMENT =================

  Future<void> deleteComment(String id) async {

    isLoading.value = true;

    try {

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.deleteComment,
        body: {"id": id},
      );

      if (res != null) {

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"],
        ).showSnackBar();

        await loadComments();

        showReplyMap.remove(id);
        isEditingMap.remove(id);

        editControllers[id]?.dispose();
        editControllers.remove(id);
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= ADD REPLY =================

  Future<void> addReply(String commentId, String text) async {

    isLoading.value = true;

    try {

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.addReply,
        body: {
          "comment_id": commentId,
          "content": text,
        },
      );

      if (res != null) {

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"],
        ).showSnackBar();

        showReplyMap[commentId] = false;

        replyCtrl(commentId).clear();

        await loadComments();
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= EDIT REPLY =================

  Future<void> editReply(String id, String newText) async {

    isLoading.value = true;

    try {

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.updateReply,
        body: {"id": id, "content": newText},
      );

      if (res != null) {

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"],
        ).showSnackBar();

        await loadComments();
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= DELETE REPLY =================

  Future<void> deleteReply(String id) async {

    isLoading.value = true;

    try {

      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.deleteReply,
        body: {"id": id},
      );

      if (res != null) {

        CustomSnackBar(
          isSuccess: true,
          msg: res["msg"],
        ).showSnackBar();

        await loadComments();

        showReplyMap.remove(id);
        isEditingMap.remove(id);

        replyControllers[id]?.dispose();
        replyControllers.remove(id);
      }

    } finally {

      isLoading.value = false;

    }
  }

  /// ================= LIKE / DISLIKE =================

  void toggleLike(SingleComment comment) {

    final index = comments.indexOf(comment);

    if (index != -1) {

      comments[index] = comment.copyWith(
        // likes: (comment.likes ?? 0) + 1,
      );
    }
  }

  void toggleDisLike(SingleComment comment) {

    final index = comments.indexOf(comment);

    if (index != -1) {

      comments[index] = comment.copyWith();
    }
  }
}