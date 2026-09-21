import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pages/controllers/create_page_controller.dart';
import 'package:ontorikkho/app/modules/pages/controllers/search_page_controller.dart';

import '../controllers/pages_controller.dart';

class PagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PagesController>(
      () => PagesController(),
    );
  }
}

class PageSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPageController>(
          () => SearchPageController(),
    );
  }
}

class CreatePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePageController>(
          () => CreatePageController(),
    );
  }
}