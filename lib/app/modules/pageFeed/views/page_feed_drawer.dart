import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/manage_admin_controller.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/page_feed_controller.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/utils/extensions.dart';

import '../../../../common_widgets/custom_info_dialouge.dart';

class PageFeedDrawer extends StatelessWidget {
  PageFeedDrawer({super.key});

  final controller = Get.put(PageFeedController());

  @override
  Widget build(BuildContext context) {
    var myRole=controller.pageData.value.myRole.role;

    return Obx(
      () => Drawer(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  //================ Header ===================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(.08),
                    ),
                    child: Row(
                      children: [
                        CustomCircleAvatar(
                          width: 65.sp,
                          height: 65.sp,
                          border: 4,
                          bgColor: AppColors.primaryColor.withOpacity(.15),
                          image: controller.pageData.value.profileImage ?? "",
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.pageData.value.name ?? "",
                                style: AppTextStyles.header(fontSize: 18.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                controller.pageData.value.myRole ?? "",
                                style: AppTextStyles.body(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      /*  CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18.sp,
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                        ),*/
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
                      children: [
                    /*   if(myRole.canEdit) _tile(
                          icon: Icons.people_alt_outlined,
                          title: "Invite Friends",
                          onTap: () {
                            Get.back();
                            Get.toNamed(Routes.MANAGE_ADMIN_PAGE);
                          },
                        ),*/

                      if(myRole.canManage) _tile(
                          icon: Icons.admin_panel_settings_outlined,
                          title: "Manage Admin",
                          onTap: () {
                            Get.back();

                            late final ManageAdminController
                            manageAdminController;

                            if (Get.isRegistered<ManageAdminController>()) {
                              manageAdminController =
                                  Get.find<ManageAdminController>();
                            } else {
                              manageAdminController = Get.put(
                                ManageAdminController(),
                              );
                            }

                            manageAdminController.page.value =
                                controller.pageData.value;
                            manageAdminController.getAdmins(
                              pageId: controller.pageId.toString(),
                            );

                            Get.toNamed(Routes.MANAGE_ADMIN_PAGE);
                          },
                        ),

                        if(myRole.canDelete) _tile(
                          icon: Icons.delete_outline,
                          title: "Delete Page",
                          color: Colors.red,
                          onTap: () {
                            Get.back();
                            Get.dialog(
                              CustomInfoDialog(
                                title: "Delete Page",
                                description:
                                "Are you sure you want to delete this Page?"
                                    "All data will be lost.",
                                infoIcon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size: 60,
                                ),
                                declineText: "Cancel",
                                acceptText: "Delete",
                                onAccept: () {
                                  controller.deletePage(pageId: controller.pageId);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Text(
                      "Ontorikkho",
                      style: AppTextStyles.body(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              if (controller.isLoading.value) const LoadingScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: Icon(icon, color: color ?? AppColors.primaryColor),
        title: Text(
          title,
          style: AppTextStyles.body(color: color ?? AppColors.headerText),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
