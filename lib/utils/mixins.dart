import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

mixin ScrollLoadMoreMixin {
  bool _attached = false;

  void setupLoadMore({
    required ScrollController controller,
    required RxBool isLoadingMore,
    required VoidCallback onLoadMore,
    double offset = 100,
  }) {
    if (_attached) return;
    _attached = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(() {
        if (!controller.hasClients) return;

        final max = controller.position.maxScrollExtent;
        final current = controller.position.pixels;

        if (current >= max - offset) {
          if (!isLoadingMore.value) {
            onLoadMore();
          }
        }
      });
    });
  }
}