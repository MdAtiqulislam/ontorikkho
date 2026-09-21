import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/notification_selector.dart';

class PushNotificationController extends GetxController {

  final options = [
    NotificationOption(id: "all", label: "All", icon: Icons.notifications),
   // NotificationOption(id: "communication", label: "Communication", icon: Icons.chat),
    NotificationOption(id: "none", label: "None", icon: Icons.notifications_off),
  ];

  var selectedOption = "all".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


}
