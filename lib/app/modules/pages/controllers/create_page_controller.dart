import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/pages/models/page_category_model.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';
import '../../../../services/my_pages_service.dart';

class CreatePageController extends GetxController {
  final isLoading = false.obs;
  final isUpdating = false.obs;

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  final picker = ImagePicker();

  final selectedProfileImage = RxnString();
  final selectedCoverImage = RxnString();

  final selectedPageType = Rxn<PageType>();

  final pageCategories = <PageCategory>[].obs;
  final selectedCategory = Rxn<PageCategory>();

  //final myPages = <PageModel>[].obs;

  @override
  void onClose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }

  /// ================= CREATE PAGE =================

  Future<void> submit() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        final body = <String, String>{
          "name": nameCtrl.text.trim(),
          "description": descCtrl.text.trim(),
          "page_type": selectedPageType.value?.value ?? "",
          if (selectedCategory.value?.id != null)
            "page_category_id": selectedCategory.value!.id.toString(),
        };

        final files = <String, String>{
          if (selectedProfileImage.value != null)
            "profile_image": selectedProfileImage.value!,
          if (selectedCoverImage.value != null)
            "cover_image": selectedCoverImage.value!,
        };

        final res = await RemoteServices.postWithMultipleImages(
          endpoint: APIEndPoints.createPage,
          requestType: "POST",
          body: body,
          files: files,
        );

        if (res != null) {
         // await getMyPages();
          await Get.find<MyPageService>().refresh();

        /*  if (Get.isRegistered<PagesController>()) {
            Get.find<PagesController>().myPages.assignAll(myPages);
          }*/

        /*  if (Get.isRegistered<ProfileFeedController>()) {
            Get.find<ProfileFeedController>().myPages.assignAll(myPages);
          }*/

          Get.back(result: true);
        }

        return res;
      },
    );
  }

  /// ================= PAGE CATEGORIES =================

  Future<void> getCategories() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        final res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getPageCategories,
          parameters: {
            "page_type": selectedPageType.value?.value ?? "",
          },
        );

        if (res != null) {
          final model = PageCategoryModel.fromJson(res);
          pageCategories.assignAll(model.data?.categories ?? []);
        }

        return res;
      },
    );
  }

  /// ================= MY PAGES =================

/*  Future<void> getMyPages() async {
    await _handleLoading(
      loader: isLoading,
      request: () async {
        final res = await RemoteServices.getRequest(
          endpoint: APIEndPoints.getMyPages,
        );

        if (res == null) return null;

        final model = MyPagesModel.fromJson(res);

        myPages.assignAll(model.data?.myPages ?? []);

        return model;
      },
    );
  }*/

  /// ================= PROFILE PHOTO =================

  Future<void> selectProfilePicture(ImageSource source) async {
    final image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image == null) return;

    selectedProfileImage.value = image.path;
  }

  /// ================= COVER PHOTO =================

  Future<void> selectCoverPhoto(ImageSource source) async {
    final image = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) return;

    selectedCoverImage.value = image.path;
  }

  /// ================= COMMON LOADER =================

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
}