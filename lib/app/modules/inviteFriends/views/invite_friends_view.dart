import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_bottom_sheet.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../controllers/invite_friends_controller.dart';

class InviteFriendsView extends GetView<InviteFriendsController> {
  const InviteFriendsView({super.key});

  final List<Color> softColors = const [
    Color(0xFFB3E5FC),
    Color(0xFFC8E6C9),
    Color(0xFFFFF9C4),
    Color(0xFFD1C4E9),
    Color(0xFFFFCCBC),
    Color(0xFFB2DFDB),
    Color(0xFFFFE0B2),
    Color(0xFFBBDEFB),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(showBackButton: true,title: "Invite Friends",),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Column(
          children: [
            // 1. Top Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (val) => controller.search(val),
                decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.groupedContacts.isEmpty) {
                  return const Center(child: Text("No contacts found"));
                }

                final sections = controller.groupedContacts.keys.toList()..sort();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: sections.length,
                  itemBuilder: (context, sectionIndex) {
                    final letter = sections[sectionIndex];
                    final contacts = controller.groupedContacts[letter]!;

                    return _buildSection(letter, contacts);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String letter, List contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          width: double.infinity,
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Column(
          children:
              contacts.map<Widget>((contact) {
                final phone =
                    contact.phones!.isNotEmpty
                        ? contact.phones?.first.value
                        : "";
                final index = contacts.indexOf(contact);

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: softColors[index % softColors.length],
                        child: HeaderText(
                          text: _getInitials(contact.displayName),
                        ),
                      ),
                      title: HeaderText(
                        text:
                            contact.displayName?.isNotEmpty ?? false
                                ? contact.displayName!
                                : "Unknown",
                        align: TextAlign.start,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                      subtitle: Text(
                        phone ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100.w,
                        height: 35.h,
                        child: AppButton(
                          text: "Invite",
                          onTap: () {
                            controller.initMessage(contact: contact);
                            inviteFriendsForm(contact: contact);
                          },
                          showBorder: false,
                          bgColor: softColors[index % softColors.length],
                          textColor: AppColors.bodyText,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0.5,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.grey,
                    ),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "?";
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  void inviteFriendsForm({required ContactInfo contact}) {
    showCustomBottomSheet(
      title: "Send SMS Invitation",
      content: Obx(
        () => Stack(
          children: [
            // MAIN UI
            SizedBox(
              width: double.infinity,
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppDimensions.sectionPadding.h),
                    HeaderText(
                      text:
                          "'${contact.displayName}' isn't on Ontorikkho? Do you want to invite him/her to join?",
                      maxLine: 10,
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.normal,
                      align: TextAlign.start,
                    ),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    Container(
                      width: 50.sp,
                      height: 50.sp,
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withAlpha(30),
                      ),
                      child: Icon(Icons.account_circle_sharp),
                    ),
                    SizedBox(height: AppDimensions.contentPadding.h,),
                    HeaderText(text: contact.displayName ?? "",maxLine: 2,),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                    CustomTextField(
                      title: "Message",
                      maxLine: 20,
                      minLine: 5,
                      controller: controller.messageController,
                    ),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                    AppButton(
                      text: "Send Invitation",
                      onTap: () {
                        controller.invite(contact.phones?.first.value ?? "");
                      },
                      bgColor: AppColors.primaryColor,
                      showBorder: false,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: AppDimensions.contentPadding.h),
                    AppButton(
                      text: "Not now",
                      onTap: () {
                        Get.back();
                      },
                      textColor: AppColors.bodyText,
                      showBorder: false,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: AppDimensions.sectionPadding.h),
                  ],
                ),
              ),
            ),

            // OVERLAY LOADER
            if (controller.sendingInvitation.value)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.3),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
