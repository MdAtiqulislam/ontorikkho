/*
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/singlePostView/controllers/single_post_view_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../models/pagination_model.dart';
import '../models/notifications_model.dart';

class NotificationsController extends GetxController with ScrollLoadMoreMixin {

  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  final notificationsModel = NotificationsModel().obs;
  final notificationsList = <SingleNotification>[].obs;
  final pagination = Pagination().obs;

  final scrollController = ScrollController();

  int get unreadCount => notificationsModel.value.unreadCount ?? 0;

  @override
  void onReady() {
    super.onReady();

    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
     // nextPageUrl: pagination.value.nextPageUrl,
      onLoadMore: _handleLoadMore,
    );
  }

  void _handleLoadMore() {
    final page = pagination.value;
    if (isLoadingMore.value) return;
    if (page.currentPage == page.lastPage) return;
    final nextUrl = page.nextPageUrl ??
        "${APIEndPoints.getNotification}?page=${(page.currentPage ?? 0) + 1}";
    pagination.value = page.copyWith(
      nextPageUrl: nextUrl,
    );
    loadMoreNotifications();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// ---------------- GET NOTIFICATIONS ----------------
  Future<void> getNotifications() async {
    try {
      isLoading.value = true;

      final data = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getNotification,
      );

      if (data != null) {
        final model = NotificationsModel.fromJson(data);

        notificationsModel.value = model;
        notificationsList.value = model.data ?? [];
        pagination.value = model.pagination ?? Pagination();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- MARK AS READ ----------------
  Future<void> markAsRead(String notificationId) async {

    final body = {"notification_id": notificationId};

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.markNotificationAsRead,
        body: body,
      );

      if (res != null) {

        final index =
        notificationsList.indexWhere((n) => n.id == notificationId);

        if (index != -1) {
          notificationsList[index] =
              notificationsList[index].copyWith(readAt: DateTime.now());
        }

        /// decrease unread count locally
        final count = notificationsModel.value.unreadCount ?? 0;

        if (count > 0) {
          notificationsModel.value =
              notificationsModel.value.copyWith(unreadCount: count - 1);
        }
      }
    } catch (e) {
      debugPrint("markAsRead error: $e");
    }
  }

  /// ---------------- LOAD MORE ----------------
  Future<void> loadMoreNotifications() async {

    if (isLoadingMore.value || pagination.value.nextPageUrl == null) return;

    try {
      isLoadingMore.value = true;

      final data = await RemoteServices.getRequest(
        endpoint: pagination.value.nextPageUrl!,
      );

      if (data != null) {

        final newModel = NotificationsModel.fromJson(data);

        notificationsList.addAll(newModel.data ?? []);

        pagination.value = newModel.pagination ?? Pagination();
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// ---------------- DELETE ONE ----------------
  Future<void> removeNotificationById({
    required String notificationId,
  }) async {

    final body = {"notification_id": notificationId};

    final data = await RemoteServices.postRequest(
      endpoint: APIEndPoints.deleteNotificationById,
      body: body,
    );

    if (data != null) {
      notificationsList.removeWhere((n) => n.id == notificationId);
    }
  }

  /// ---------------- DELETE ALL ----------------
  Future<void> removeAllNotifications() async {

    final data = await RemoteServices.postRequest(
      endpoint: APIEndPoints.deleteAllNotifications,
    );

    if (data != null) {
      notificationsList.clear();
    }
  }

  /// ---------------- DELETE READ ----------------
  Future<void> removeReadNotifications() async {

    final data = await RemoteServices.postRequest(
      endpoint: APIEndPoints.deleteReadNotifications,
    );

    if (data != null) {
      notificationsList.removeWhere((n) => n.readAt != null);
    }
  }

  /// ---------------- REFRESH ----------------
  Future<void> refreshPosts() async {
    await getNotifications();
  }

  /// ---------------- TAP HANDLER ----------------
  Future<void> handleNotificationTap(
      SingleNotification notification) async
  {

    if (notification.readAt == null) {
      await markAsRead(notification.id!);
    }

    final controller = Get.put(SinglePostViewController());

    final postId = notification.data?.postId?.toString();
    final commentId = notification.data?.commentId?.toString();

    switch (notification.type?.toLowerCase())
    {

      case "post_reaction":

        controller.viewAll.value = false;
        controller.post.value=SinglePostModel();
        controller.getPostDetails(postId ?? "");

        Get.toNamed(Routes.SINGLE_POST_VIEW);
        break;

      case "comment":

        controller.viewAll.value = false;
        controller.post.value=SinglePostModel();
        controller.getPostDetailsWithCommentId(
          postId ?? "",
          commentId ?? "",
        );
        case "friend_request":
          removeNotificationById(notificationId: notification.id??"");
        Get.toNamed(Routes.FRIENDS);
        break;
    }
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/mixins.dart';

import '../../../../constraints/api_end_points.dart';
import '../../../../models/pagination_model.dart';
import '../../../../utils/util.dart';
import '../../../routes/app_pages.dart';
import '../../forYou/models/posts_model.dart';
import '../../singlePostView/controllers/single_post_view_controller.dart';
import '../models/notifications_model.dart';

class NotificationsController extends GetxController
    with ScrollLoadMoreMixin {

  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  final notificationsModel = NotificationsModel().obs;
  final notificationsList = <SingleNotification>[].obs;
  final pagination = Pagination().obs;

  final scrollController = ScrollController();

  int get unreadCount => notificationsModel.value.unreadCount ?? 0;


  @override
  void onReady() {
    super.onReady();

    getNotifications(); // 🔥 first load

    setupLoadMore(
      controller: scrollController,
      isLoadingMore: isLoadingMore,
      onLoadMore: _handleLoadMore,
    );
  }

  /// ---------------- LOAD MORE TRIGGER ----------------
  void _handleLoadMore() {
    final nextUrl = buildNextPageUrl(
      page: pagination.value,
      baseUrl: APIEndPoints.getNotification,
    );

    if (nextUrl == null) return;

    loadMore(nextUrl);
  }

  /// ---------------- FIRST LOAD ----------------
  Future<void> getNotifications() async {
    try {
      isLoading.value = true;

      final data = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getNotification,
      );

      if (data != null) {
        final model = NotificationsModel.fromJson(data);

        notificationsList.value = model.data ?? [];
        pagination.value = model.pagination ?? Pagination();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- MARK AS READ ----------------
  Future<void> markAsRead(String notificationId) async {

    final body = {"notification_id": notificationId};

    try {
      final res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.markNotificationAsRead,
        body: body,
      );

      if (res != null) {

        final index =
        notificationsList.indexWhere((n) => n.id == notificationId);

        if (index != -1) {
          notificationsList[index] =
              notificationsList[index].copyWith(readAt: DateTime.now());
        }

        /// decrease unread count locally
        final count = notificationsModel.value.unreadCount ?? 0;

        if (count > 0) {
          notificationsModel.value =
              notificationsModel.value.copyWith(unreadCount: count - 1);
        }
      }
    } catch (e) {
      debugPrint("markAsRead error: $e");
    }
  }


  /// ---------------- LOAD MORE ----------------
  Future<void> loadMore(String url) async {
    if (isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;

      final data = await RemoteServices.getRequest(endpoint: url);

      if (data != null) {
        final model = NotificationsModel.fromJson(data);

        final newList = model.data ?? [];

        /// ❌ no data → stop further calls
        if (newList.isEmpty) return;

        /// append list
        notificationsList.addAll(newList);

        /// 🔥 smart pagination update
        pagination.value = pagination.value.copyWith(
          currentPage: model.pagination?.currentPage ??
              (pagination.value.currentPage ?? 0) + 1,

          lastPage:
          model.pagination?.lastPage ?? pagination.value.lastPage,

          nextPageUrl: model.pagination?.nextPageUrl,
        );
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// ---------------- DELETE ONE ----------------
  Future<void> removeNotificationById({
    required String notificationId,
  }) async {

    final body = {"notification_id": notificationId};

    final data = await RemoteServices.postRequest(
      endpoint: APIEndPoints.deleteNotificationById,
      body: body,
    );

    if (data != null) {
      notificationsList.removeWhere((n) => n.id == notificationId);
    }
  }

  /// ---------------- DELETE ALL ----------------
  Future<void> removeAllNotifications() async {

    final data = await RemoteServices.postRequest(
      endpoint: APIEndPoints.deleteAllNotifications,
    );

    if (data != null) {
      notificationsList.clear();
    }
  }

  /// ---------------- DELETE READ ----------------
  Future<void> removeReadNotifications() async {

    final data = await RemoteServices.postRequest(
      endpoint: APIEndPoints.deleteReadNotifications,
    );

    if (data != null) {
      notificationsList.removeWhere((n) => n.readAt != null);
    }
  }


  /// ---------------- REFRESH ----------------
  Future<void> refreshData() async {
    pagination.value = Pagination(); // reset
    notificationsList.clear();
    await getNotifications();
  }

  /// ---------------- TAP HANDLER ----------------
  Future<void> handleNotificationTap(
      SingleNotification notification) async
  {
    if (notification.readAt == null) {
      await markAsRead(notification.id!);
    }

    final controller = Get.put(SinglePostViewController());

    final postId = notification.data?.postId?.toString();
    final commentId = notification.data?.commentId?.toString();

    switch (notification.type?.toLowerCase()) {
      case "post_reaction":
        controller.viewAll.value = false;
        controller.post.value = SinglePostModel();
        controller.getPostDetails(postId ?? "");

        Get.toNamed(Routes.SINGLE_POST_VIEW);
        break;

      case "comment":
        controller.viewAll.value = false;
        controller.post.value = SinglePostModel();
        controller.getPostDetailsWithCommentId(
          postId ?? "",
          commentId ?? "",
        );
      case "friend_request":
        removeNotificationById(notificationId: notification.id ?? "");
        Get.toNamed(Routes.FRIENDS);
        break;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}