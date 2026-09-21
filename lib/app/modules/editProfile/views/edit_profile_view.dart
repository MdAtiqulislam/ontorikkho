import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/editProfile/views/edit_profile_shimmer.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_drop_down_field.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/custom_phone_field.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/common_widgets/file_circle_avater.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/custom_check_box.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
   EditProfileView({super.key});
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true, title: "Edit Profile"),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () =>
              controller.isLoading.value
                  ? EditProfileShimmer()
                  : Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.horizontalPadding.w,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: AppDimensions.widgetPadding.h),
                            editProfileForm(),
                            SizedBox(height: AppDimensions.widgetPadding.h),
                          ],
                        ),
                      ),
                      if(controller.isUpdating.value)LoadingScreen()
                    ],
                  ),
        ),
      ),
    );
  }

  Widget editProfileForm() {
    return Form(
      key: _formKey,
      child: CustomCard(
        horizontalPadding: AppDimensions.horizontalPadding.w,
        verticalPadding: AppDimensions.verticalPadding.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HeaderText(text: "Profile Picture", size: 12),
            ),
            controller.profilePictureFile.isNotEmpty
                ? Center(
                  child: FileCircleAvatar(
                    imageFile: controller.profilePictureFile.first,
                    width: 80.sp,
                    height: 80.sp,
                    border: 5,
                    showEditIcon: true,
                    onEditTap: (){
                      chooseFileOption(fileType: "PROFILE");
                    },
                    editIcon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    editButtonBg: Colors.black,
                  ),
                )
                : Center(
                  child: CustomCircleAvatar(
                    width: 80.sp,
                    height: 80.sp,
                    border: 5,
                    showEditIcon: true,
                    onEditTap: () {
                      chooseFileOption(fileType: "PROFILE");
                    },
                    image: controller.user.value.data?.profileImage ?? "",
                    editIcon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    editButtonBg: Colors.black,
                  ),
                ),

            SizedBox(height: AppDimensions.sectionPadding.h),

            CustomTextField(
              title: "Name",
              isRequired: true,
              hintText: "Full Name",
              validatorText: "Required",
              controller: controller.nameController,
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomTextField(
              isRequired: true,
              title: "Email",
              hintText: "abc@email.com",
              preFix: Icon(Icons.email_outlined, size: 14.sp),
              validatorText: "Required",
              controller: controller.emailController,
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomPhoneTextField(
              title: "Phone Number",
              isRequired: true,
              selectedCountry: controller.selectedPhoneCountry,
              callingCode: '',
              controller: controller.phoneController,
              onChange: (value) {
                controller.selectedPhoneCountry = value;
              },
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomPhoneTextField(
              title: "Emergency Contact",
              isRequired: false,
              onChange: (value) {
                controller.selectedEmergencyContactCountry = value;
              },

              callingCode: '',
              controller: controller.emergencyContactController,
              selectedCountry: controller.selectedEmergencyContactCountry,
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomDropDownField(
              title: "Gender",
              isRequired: true,
              itemList: controller.genders,
              onChange: (value) {
                controller.selectedGender = value ?? "";
              },
              hintText: "--Select Gender--",
              value:
                  controller.selectedGender != ""
                      ? controller.selectedGender
                      : null,
              validatorText: "Required",
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomDropDownField(
              title: "Blood Group",
              itemList: controller.bloodGroup,
              onChange: (value) {
                controller.selectedBloodGroup = value ?? "";
              },
              value:
                  controller.selectedBloodGroup != ""
                      ? controller.selectedBloodGroup
                      : null,
              hintText: "--Select Blood Group--",
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomTextField(
              title: "Address",
              hintText: "Insert Address",
              maxLine: 10,
              minLine: 2,
              controller: controller.addressController,
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomDropDownField(
              title: "Highest Education Degree",
              isRequired: true,
              itemList: controller.educationDegrees,
              onChange: (value) {
                controller.getSelectedDegree(value);
              },
              hintText: "--Select Education Degree--",
              value: controller.selectedDegree.value.name,
              validatorText: "Required",
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomTextField(
              title: "Do you play sports?",
              hintText: "Enter Sports",
              maxLine: 10,
              minLine: 1,
              controller: controller.sportsController,
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            CustomTextField(
              title: "Do you have any hobbies?",
              hintText: "Enter hobbies",
              maxLine: 10,
              minLine: 1,
              controller: controller.hobbiesController,
            ),
            SizedBox(height: AppDimensions.contentPadding.h),
            IgnorePointer(
              ignoring: true,
              child: CustomDropDownField(
                title: "Membership",
                isRequired: true,
                itemList: controller.membershipTypes,
                onChange: (value) {
                  controller.getSelectedMemberShip(value);
                },
                value:
                    controller.selectedMembership.value.title?.isEmpty ?? true
                        ? null
                        : controller.selectedMembership.value.title,
                hintText: "--Select Membership Plan--",
                validatorText: "Required",
              ),
            ),

            SizedBox(height: AppDimensions.contentPadding.h),
            Obx(() {
              final checkboxes = controller.getMembershipFeeCheckboxes();

              // ✅ Fill initial false values for each label
              for (var label in checkboxes) {
                controller.acceptedTerms.putIfAbsent(label, () => false);
              }

              return Column(
                children: List.generate(checkboxes.length, (index) {
                  final label = checkboxes[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index != checkboxes.length - 1 ? 10.0 : 0.0,
                    ),
                    child: CustomCheckboxTile(
                      value: controller.acceptedTerms[label] ?? false,
                      onChanged: (val) {
                        controller.acceptedTerms[label] = val;
                      },
                      label: label,
                    ),
                  );
                }),
              );
            }),
            SizedBox(height: AppDimensions.sectionPadding.h),
            Obx(() {
              return AppButton(
                text: "Save",
                onTap: controller.areAllTermsAccepted
                    ? () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.submitEditForm();
                  }
                }
                    : null, // disabled if not all accepted
                textTransform: TextTransform.none,
                  showBorder: false,
                bgColor: controller.areAllTermsAccepted
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withAlpha((.5*254).toInt()) // disabled color
              );
            })

          ],
        ),
      ),
    );
  }

  void chooseFileOption({required String fileType}) {
    showCustomBottomSheet(
      title: "Select an action",
      content: Column(
        children: [
          // Camera Option
          _buildOption(
            iconPath: AppImagePath.cameraIcon,
            text: "Open Camera",
            subText: "Capture an image using your camera",
            onTap: () {
              controller.selectImage(
                source: ImageSource.camera,
                fileType: fileType,
              );
              Get.back(); // Close bottom sheet
            },
          ),
          const Divider(),

          // Gallery Option
          _buildOption(
            iconPath: AppImagePath.galleryIcon,
            text: "Choose File",
            subText: "Select file from gallery",
            onTap: () {
              controller.handleDocumentSelection(fileType: fileType);
              Get.back(); // Close bottom sheet
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String iconPath,
    required String text,
    required String subText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Row(
              children: [
                Image.asset(iconPath, height: 30.h),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: text),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: BodyText(
                        text: subText,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
