import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/notifications/controllers/notifications_controller.dart';
import '../../routes/app_pages.dart';


class AppBarController extends GetxController {
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    Get.find<NotificationsController>().getNotifications();
  }


  void editUserInfo() {}

  void handleNotificationClick() {

    NotificationsController controller;

    if (Get.isRegistered<NotificationsController>()) {
      controller = Get.find<NotificationsController>();
    } else {
      controller = Get.put(NotificationsController());
    }

    controller.getNotifications();

    if (Get.currentRoute != Routes.NOTIFICATIONS) {
      Get.toNamed(Routes.NOTIFICATIONS);
    }
  }
}
