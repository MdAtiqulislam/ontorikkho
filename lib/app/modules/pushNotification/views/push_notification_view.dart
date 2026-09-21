import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/pushNotification/views/notification_item.dart';
import 'package:ontorikkho/common_widgets/custom_list_tile.dart';
import 'package:ontorikkho/common_widgets/notification_toggle.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';

import '../../../../common_widgets/custom_card.dart';
import '../../../../constraints/dimensions.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/push_notification_controller.dart';
import 'notification_selector.dart';

class PushNotificationView extends GetView<PushNotificationController> {
  const PushNotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          title: "Notification Settings",
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
             // minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    SectionHeader(title: "What Notifications to Receive",showMoreButton: false,),
                   /* Obx(() => NotificationSelector(
                      options: controller.options,
                      selectedId: controller.selectedOption.value,
                      onChanged: (id) {
                        controller.selectedOption.value = id;
                      },
                    )
                    ),*/

                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NotificationItem(
                            isSelected: true,//selectedId == options[0].id,
                            icon: Icons.notifications_active,//options[0].icon,
                            label: "All",
                            onTap: (){},
                          ),
                          SizedBox(width: AppDimensions.contentPadding.w,),
                          NotificationItem(
                            isSelected: false,//selectedId == options[0].id,
                            icon: Icons.notifications_active,//options[0].icon,
                            label: "All",
                            onTap: (){},
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
