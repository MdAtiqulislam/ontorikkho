import 'package:get/get.dart';

import '../controllers/single_post_view_controller.dart';

class SinglePostViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SinglePostViewController>(
      () => SinglePostViewController(),
    );
  }
}
