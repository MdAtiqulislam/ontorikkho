import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../common_widgets/custom_info_dialouge.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/manage_admin_controller.dart';
import 'admin_card.dart';


class ManageAdminView extends GetView<ManageAdminController> {
  const ManageAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Manage Admin"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: controller.showAddAdminBottomSheet,
          backgroundColor: AppColors.primaryColor,
          icon: const Icon(Icons.person_add,color: Colors.white,),
          label:  Text("Add Admin",style: AppTextStyles.body(color: Colors.white),),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  /// ================= LOAD MORE =================
                  if (controller.isLoadingMore.value)
                    const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.builder(
                      itemCount: controller.admins.length,
                      itemBuilder: (_, index) {
                        final admin = controller.admins[index];
                        return AdminCard(
                          admin: admin,
                          userId: controller.user.value.userId.toString(),
                          onRemove: () {
                            Get.dialog(
                              CustomInfoDialog(
                                title: "Remove Admin",
                                description:
                                "Are you sure you want to remove ${admin.user?.name ?? "this user"} as an admin? "
                                    "They will lose all admin privileges for this page.",
                                infoIcon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size: 60,
                                ),
                                declineText: "Cancel",
                                acceptText: "Remove",
                                onAccept: () {
                                  controller.removeAdmin(
                                    userId: admin.userId.toString(),
                                    pageId: controller.page.value.id.toString(),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                ],
              ),

              /// ================= GLOBAL LOADER =================
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }
}


