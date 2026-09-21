import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/notifications/views/single_notification_view.dart';

import '../../../../common_widgets/custom_loading_screen.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:CustomAppBar(showBackButton: true,title: "Notifications",actions: [
        IgnorePointer(
          ignoring: controller.notificationsList.isEmpty,
          child: PopupMenuButton<String>(
          icon: const Icon(
            Icons.clear_all,
            color: Colors.white,
          ),
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "remove_read",
              child: Row(
                children: [
                  const Icon(Icons.mark_email_read, size: 20),
                  const SizedBox(width: 12),
                  const Text(
                    "Remove All Read",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: "remove_all",
              child: Row(
                children: const [
                  Icon(Icons.delete_forever, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text(
                    "Remove All",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) async {

            final bool? confirm = await Get.dialog<bool>(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text("Confirm"),
                content: Text(
                  value == "remove_read"
                      ? "Are you sure you want to remove all read notifications?"
                      : "Are you sure you want to remove ALL notifications?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              if (value == "remove_read") {
                controller.removeReadNotifications();
              } else {
                controller.removeAllNotifications();
              }

              Get.snackbar(
                "Success",
                value == "remove_read"
                    ? "All read notifications removed"
                    : "All notifications removed",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
                ),
        )
        ],),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.refreshData,
                child: CustomScrollView(
                  controller: controller.scrollController,

                  slivers: [

                    SliverList(

                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final notification = controller.notificationsList[index];
                          return SingleNotificationView(notification: notification);
                        },
                        childCount: controller.notificationsList.length,
                      ),
                    ),

                    if (controller.isLoadingMore.value)
                      SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),

              if(controller.isLoading.value)LoadingScreen()
            ],
          );
        }),
      ),
    );
  }
}
