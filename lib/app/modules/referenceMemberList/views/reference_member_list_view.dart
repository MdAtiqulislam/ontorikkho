import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import '../controllers/reference_member_list_controller.dart';

class ReferenceMemberListView extends GetView<ReferenceMemberListController> {
  const ReferenceMemberListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Reference Member",
          showBackButton: true,
          showNotificationButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔍 Search bar
              TextField(
                decoration: const InputDecoration(
                  hintText: "Search Reference Member",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.search,
              ),
              const SizedBox(height: 16),

              // 👥 Member list
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.memberList.isEmpty) {
                    return const Center(child: Text("No members found"));
                  }

                  return ListView.separated(
                    itemCount: controller.memberList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final member = controller.memberList[index];
                      return ListTile(
                        title: Text(member.name ?? ''),
                        onTap: () {
                          // 🔁 Return selected member to previous page
                          Get.back(result: member);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
