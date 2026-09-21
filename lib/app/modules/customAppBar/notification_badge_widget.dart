import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../notifications/controllers/notifications_controller.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();

    return Obx(() {
      if (controller.unreadCount == 0) {
        return const SizedBox();
      }

      return Positioned(
        right: 5,
        top: 5,
        child: IgnorePointer(
          ignoring: true,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Center(
              child: Text(
                controller.unreadCount > 99
                    ? "99+"
                    : controller.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}