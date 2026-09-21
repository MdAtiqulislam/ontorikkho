import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pages/bindings/pages_binding.dart';
import 'package:ontorikkho/app/modules/pages/models/following_pages_model.dart';
import 'package:ontorikkho/app/modules/pages/models/recommended_pages_model.dart';
import 'package:ontorikkho/app/modules/pages/views/create_page_view.dart';
import 'package:ontorikkho/app/modules/pages/views/pages_list_view.dart';
import 'package:ontorikkho/app/modules/pages/views/search_page_view.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/services/my_pages_service.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';

import '../../profileFeed/models/my_pages_model.dart';
import '../models/page_data_model.dart';
import '../models/page_model.dart';

class PagesController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isUpdating = false.obs;

  var pagesList = <PageModel>[].obs;
  var pagination = Pagination().obs;

 // var myPages = <PageModel>[].obs;
  final myPageService = Get.find<MyPageService>();

  Future<void> initData() async {}

  void goToSearchPage() {
    Get.to(() => SearchPageView(), binding: PageSearchBinding());
  }

  Future<void> changeView({required PageFilterType type}) async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        switch (type) {
          case PageFilterType.create:
            await Get.to(() => CreatePageView(), binding: CreatePageBinding());
            break;

          case PageFilterType.followed:
            Get.to(() => PagesListView(title: type.label));
            await getFollowingPages();
            break;

          case PageFilterType.invites:
            Get.to(() => PagesListView(title: type.label));
            await getInvitedPages();
            break;

          case PageFilterType.recommended:
            Get.to(() => PagesListView(title: type.label));
            await getRecommendedPages();
            break;
        }
        return null;
      },
    );
  }

  Future<void> getRecommendedPages() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        pagesList.clear();
        pagination.value = Pagination();

        var response = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getRecommendedPages,
        );

        if (response != null) {
          var data = RecommendedPagesModel.fromJson(response);
          pagesList.value = data.data?.pages ?? [];
          pagination.value = data.data?.pagination ?? Pagination();
        }
        return null;
      },
    );
  }

  Future<void> getInvitedPages() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        pagesList.clear();
        pagination.value = Pagination();

        var response = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getInvitedPages,
        );

        if (response != null) {
          var data = RecommendedPagesModel.fromJson(response);
          pagesList.value = data.data?.pages ?? [];
          pagination.value = data.data?.pagination ?? Pagination();
        }
        return null;
      },
    );
  }

  Future<void> getFollowingPages() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        pagesList.clear();
        pagination.value = Pagination();

        var response = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getFollowingPages,
        );
        if (response != null) {
          var data = FollowingPagesModel.fromJson(response);
          pagesList.value = data.data?.pages??[];
          pagination.value = data.data?.pagination ?? Pagination();
        }
        return null;
      },
    );
  }

  Future<void> getMyPages() async {
    await myPageService.loadMyPages();
  }

 /* Future<void> getMyPages() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        var res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getMyPages,
        );

        if (res == null) return null;

        final model = MyPagesModel.fromJson(res);
        myPages.value = model.data?.myPages ?? [];

        return null;
      },
    );
  }*/

  Future<T?> _handleLoading<T>({
    required RxBool loader,
    required Future<T?> Function() request,
  }) async
  {
    loader.value = true;
    try {
      return await request();
    } finally {
      loader.value = false;
    }
  }

  Future<void> handelPageAction({
    required PageActionType action,
    required String pageId,
  }) async
  {
    switch (action) {
      case PageActionType.follow:
        await _followPage(pageId);
        break;

      case PageActionType.unfollow:
        await _unfollowPage(pageId);
        break;

      case PageActionType.remove:
        await _removePageFromFollow(pageId);
        break;

      case PageActionType.accept:
        await _acceptPageInvitation(pageId);
        break;

      case PageActionType.denied:
        await _deniedPageInvitation(pageId);
        break;

      case PageActionType.block:
        await _blockPage(pageId);
        break;

      case PageActionType.unblock:
        await _unblockPage(pageId);
        break;

      default:
        break;
    }
  }

  /// =========================
  /// UPDATE HELPERS
  /// =========================

  void _updatePage(String pageId, PageDataModel updated) {
    final index = pagesList.indexWhere(
          (e) => e.page?.id.toString() == pageId,
    );

    if (index == -1) return;

    pagesList[index] = pagesList[index].copyWith(page: updated);
    pagesList.refresh();
  }

  /// =========================
  /// FOLLOW
  /// =========================

  Future<void> _followPage(String pageId) async {
    await _handleLoading(
      loader: isUpdating,
      request: () async {
        final res = await RemoteServices.postRequest(
          endpoint: APIEndPoints.markAsFollow,
          body: {"page_id": pageId},
        );

        if (res == null) return null;

        final data = res['data'];

        _updatePage(
          pageId,
          pagesList
              .firstWhere((e) => e.page?.id.toString() == pageId)
              .page!
              .copyWith(
            isFollowing: data['following'] ?? true,
            followersCount: data['followers_count'],
            pageStatus: data['following'] == true
                ? "following"
                : "notFollowing",
          ),
        );

        return null;
      },
    );
  }

  Future<void> _unfollowPage(String pageId) async {
    await _handleLoading(
      loader: isUpdating,
      request: () async {
        await RemoteServices.postRequest(
          endpoint: APIEndPoints.markAsUnfollow,
          body: {"page_id": pageId},
        );

        final page = pagesList
            .firstWhere((e) => e.page?.id.toString() == pageId)
            .page;

        if (page == null) return null;

        _updatePage(
          pageId,
          page.copyWith(
            isFollowing: false,
            pageStatus: "notFollowing",
          ),
        );

        return null;
      },
    );
  }

  /// =========================
  /// REMOVE / BLOCK ETC
  /// =========================

  Future<void> _removePageFromFollow(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.removePageFromFollow,
      body: {"page_id": pageId},
    );

    pagesList.removeWhere((e) => e.page?.id.toString() == pageId);
  }

  Future<void> _blockPage(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.blockPage,
      body: {"page_id": pageId},
    );

    final page = pagesList
        .firstWhere((e) => e.page?.id.toString() == pageId)
        .page;

    if (page == null) return;

    _updatePage(pageId, page.copyWith(isBlocked: true));
  }

  Future<void> _unblockPage(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.unblockPage,
      body: {"page_id": pageId},
    );

    final page = pagesList
        .firstWhere((e) => e.page?.id.toString() == pageId)
        .page;

    if (page == null) return;

    _updatePage(pageId, page.copyWith(isBlocked: false));
  }

  Future<void> _acceptPageInvitation(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.acceptPageInvitation,
      body: {"invitation_id": pageId},
    );
  }

  Future<void> _deniedPageInvitation(String pageId) async {
    await RemoteServices.postRequest(
      endpoint: APIEndPoints.deniedPageInvitation,
      body: {"invitation_id": pageId},
    );

    pagesList.removeWhere((e) => e.page?.id.toString() == pageId);
  }

}
