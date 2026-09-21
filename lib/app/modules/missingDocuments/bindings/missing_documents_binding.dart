import 'package:get/get.dart';

import '../controllers/missing_documents_controller.dart';

class MissingDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MissingDocumentsController>(
      () => MissingDocumentsController(),
    );
  }
}
