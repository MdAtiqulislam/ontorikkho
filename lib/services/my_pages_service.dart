import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pages/models/page_model.dart';
import 'package:ontorikkho/app/modules/profileFeed/models/my_pages_model.dart';
import '../../../constraints/api_end_points.dart';
import '../../../services/remote_services.dart';

class MyPageService extends GetxService {
  final RxList<PageModel> myPages = <PageModel>[].obs;

  final RxBool isLoading = false.obs;

  bool _loaded = false;

  @override
  void onInit() {
    super.onInit();
    loadMyPages();
  }

  Future<void> loadMyPages({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) return;

    isLoading.value = true;

    try {
      final res = await RemoteServices.getRequest(
        endpoint: APIEndPoints.getMyPages,
      );

      if (res == null) return;

      final model = MyPagesModel.fromJson(res);

      myPages.assignAll(model.data?.myPages ?? []);

      _loaded = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadMyPages(forceRefresh: true);
  }

  void addPage(PageModel page) {
    myPages.insert(0, page);
  }

  void removePage(int pageId) {
    myPages.removeWhere((e) => e.page?.id == pageId);
  }

  void updatePage(PageModel page) {
    final index = myPages.indexWhere(
          (e) => e.page?.id == page.page?.id,
    );

    if (index == -1) return;

    myPages[index] = page;
    myPages.refresh();
  }
}